import axios from 'axios';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore, Timestamp } from 'firebase-admin/firestore';
import { error } from 'firebase-functions/logger';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { google } from 'googleapis';
import fetch from 'node-fetch';

// Initialize Firebase app and Firestore
initializeApp();
const db = getFirestore();

const SCOPES = ['https://www.googleapis.com/auth/firebase.messaging'];

async function getAccessToken() {
    const key = {
        "YOUR_SERVICE_ACCOUNT_KEY" : "KEY"
    };

    const jwtClient = new google.auth.JWT(
        key.client_email,
        null,
        key.private_key,
        SCOPES,
        null
    );

    const tokens = await jwtClient.authorize();
    return tokens.access_token;
}

export const sendWateringNotifications = onSchedule('0 21 * * *', async (event) => {
    try {
        const now = Timestamp.now();
        const userRef = db.collection('users');
        const snapshot = await userRef.get();
        const today = new Date(now.toDate()); // Set to midnight UTC+0
        today.setHours(today.getHours() + 7);
        today.setHours(0, 0, 0, 0);

        for (const doc of snapshot.docs) {
            const userData = doc.data();
            const myplants = userData.myplants || [];

            for (const myplantRef of myplants) {
                const plantRef = db.collection('myplants').doc(myplantRef.id);
                const plantDoc = await plantRef.get();

                if (plantDoc.exists) {
                    const plantData = plantDoc.data();
                    const nextSiram = plantData.nextSiram;

                    const nextSiramDate = nextSiram.toDate();
                    const todayDate = new Date(today);
                    console.log(`next Siram Date: ${nextSiramDate.toDateString()}, Today Date: ${todayDate.toDateString()}`);

                    if (nextSiramDate && nextSiramDate.getDate() === todayDate.getDate() && plantData.reminder) {
                        const fcmToken = userData.fcmToken; // Assuming you store the user's FCM token in the user document
                        const accessToken = await getAccessToken();

                        const url = 'https://fcm.googleapis.com/v1/projects/rawanaman-8c43f/messages:send';

                        const messagePayload = {
                            message: {
                                token: fcmToken,
                                notification: {
                                    title: "It's Water Time!!",
                                    body: `Don't forget to water your ${plantData.name}`,
                                },
                                data: {
                                    type: "plant"
                                },
                                android: {
                                    priority: "high",
                                    notification: {
                                        channel_id: "high_importance_channel"
                                    }
                                }
                            }
                        };

                        const headers = {
                            'Authorization': `Bearer ${accessToken}`,
                            'Content-Type': 'application/json'
                        };

                        axios.post(
                            url, 
                            messagePayload, 
                            { headers }
                        ).then(response => {
                            console.log('Message successfully sent:', response.data);
                        }).catch(error => {
                            console.error('Error sending message:', error.response ? error.response.data : error.message);
                        })
                    } else {
                        console.log(`No Watering needed for plant ${plantData.name}.`)
                    }
                } else {
                    console.log(`Plant document does not exist for reference: ${plantRef.id}`);
                }
            }
        }
    } catch (error) {
        console.error('Error in sendWateringNotifications function:', error);
    }
});


const getTanggalSiram = (nilai, tanggal) => {
    const siramDalamHari = nilai;
    const lastWateredDate = tanggal.toDate();
    const nextWateringDate = new Date(lastWateredDate);
    nextWateringDate.setDate(lastWateredDate.getDate() + siramDalamHari);
    return Timestamp.fromDate(nextWateringDate);
};

const getPerawatan = async (plantRef) => {
    const plantDoc = await plantRef.get();

    if (!plantDoc.exists) {
        console.log('No plant document found!');
        return;
    }

    const plant = plantDoc.data();
    return plant.perawatan || [];
}

export const updateNextSiram = onSchedule('every hour', async (event) => {
    const now = Timestamp.now();
    const plantsRef = db.collection('myplants');
    const snapshot = await plantsRef.get();

    for (const doc of snapshot.docs){
        const plantData = doc.data();
        const currentNextSiram = plantData.nextSiram || plantData.created_at;

        // Check if nextSiram is a valid timestamp
        if (currentNextSiram && currentNextSiram.toDate() < now.toDate()) {
            // Fetch the watering frequency from the plant's data
            const perawatan = await getPerawatan(plantData.plant) || [];
            let penyiraman = 0; // Default value

            for (const item of perawatan) {
                if (item.jenis_perawatan.toLowerCase() === 'watering') {
                    penyiraman = item.nilai || penyiraman; // Update frequency if found
                    break; // Exit the loop since we found the entry
                }
            }

            // Calculate the new nextSiram date
            const newNextSiram = getTanggalSiram(penyiraman, currentNextSiram);

            // Update the document in Firestore
            await plantsRef.doc(doc.id).set({
                nextSiram: newNextSiram,
            }, { merge: true });
        }
    }
});