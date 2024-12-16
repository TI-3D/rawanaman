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

// const SCOPES = ['https://www.googleapis.com/auth/firebase.messaging'];

// async function getAccessToken() {
//     const key = {
//         "type": "service_account",
//         "project_id": "rawanaman-8c43f",
//         "private_key_id": "e1b4ba2a5221bc4d5c524b3777d858477b24efa8",
//         "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCnNkBQJw8wwRSD\nPDw47Hy8Sb9U5/N1QTw7FRhfE5lEjWPsqT7cHjXM0Rgm3m/Lkj2dlgxUTWhZW5WM\nMh4VGLHnZ+HqmqhmHh6jt6o5/XvFp2yhlggt/uw278xiwqt/tPjhMotxkqrZta33\nWpm1DLbRSPQj5qOa+Ho486PfE4ONcu9Iv+mO7JEv59UAy/ykJNNnR4TBfFvu3nfr\nnVtbY0gtZLepTFF8EvWOMhedv3YQwgiZHURYnD4eYivL/qI7Tij47GqScKbLvVZM\nQ8lv9uk155DvxscPR1k5Ui7D4iS36/tPOlvwU2Lf5xWaOMRu0LuIw6Vgpso/Z53I\n/LMuzgXHAgMBAAECggEAPfcCTVG0NOaQcfO8A4JL1UDlGRNd6slyhxiRsAYkyb01\n1wl/JHZDjLO95gWPW1rF36Svy/vlnBuu50XZVQsSPoWGOHj4x+MIirYw7I2NtRkO\nzjC5tkXehptF3CF1CX3orxeaikuGaeiEYAJgrLHZ++Ozqaw6W98R+BH929iw6xUf\n0p967I+wnbYjyGmNAeaNjpOj1D7t2UU1cPm5pdXbfQmHCD43R14P25FrGE56fiCz\nt9aIA7Qh5UQMFGuCN62w4p/vQUd7mF2KZAuPRTfxfgwlpeOsmQiMXWQTL2oVBnrg\nPB4+BVQMcobXd5qkfErTOhPH5uFrqd++R/2ji9IZeQKBgQDQ1jQ1eT5E11u2FWbI\nL6J48xl+/Yu+lEh3gWWoNd3z2+9BTeo/drWcNxBLJl0WdXMYhnY2RjZcrnDb62xF\nAgx+2HpPLUoKZ1lpgkMEP0NXk5o3hjes8VA9ejXG8QaKuhFS7iu3SPjOGJzjh3v/\nzwR+NW42v1EDk2CXok0I1D2u6QKBgQDM+YdJTjsyGanNx+f1pI2+P3EgYH60Qcm7\n2vn1+DSphrH18haLikPinhhlAXPflPM+o3hwjsSKonMbtKm3Rv3/OukPxYdIQGRW\nr8nZZOMJjUma7wzNNtW3UcF1W7OO umN4YandteTpMaeDgHChczuwBtKvEIxK9NQl\npQjmA+wBLwKBgDcDNl2fwrd/w7kDij/RzIrv/xdk0xsxFKXmgFD/X6iNl0ksrThq\nnQy5tKEXSg5QgjFDuoAxnsBrc297ZNoI4CHKBO42j/qNnxAcMGs9/w9i4o0d3izA\npNKNDv2JIKAKw+WEuB9gKaqg8TM+zXtlnVlh2dayLzUx7ZAEQSbCQj2BAoGBALZY\nrc+69tJlHjhgxKw0jZxX2A3TiiRV+l9SONhmzIKbvylrCj9s62No/Y6tsiWO3q40\nwupvN82VIw3ctLbFQySRhdBwCx9tmVW84LazF37h4D8itqLBS3LgGliLEbvBeMgZ\nKgKA1HnXoIxN8OTQHKNGDpuK/yOXljs/DCGED6olAoGAe9jdMj0c0jy3RhrgMmJv\nHnz0ioW44PVQSLgrxjZ8R9t/+q4+w/0UhzfZZ2nkGIj8uNXksrfVJlvWxW4ONko2\nvrmheUT91UsH3aRU/k6WxIpndUTxaoLtu4QQrNDut6Fths/qO4g0+Vd/f31wjaiF\n3+/DZKx0S4YxO95QMbiHDbU=\n-----END PRIVATE KEY-----\n",
//         "client_email": "rawanaman-notification@rawanaman-8c43f.iam.gserviceaccount.com",
//         "client_id": "115495124160994826962",
//         "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//         "token_uri": "https://oauth2.googleapis.com/token",
//         "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//         "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/rawanaman-notification%40rawanaman-8c43f.iam.gserviceaccount.com",
//         "universe_domain": "googleapis.com"
//     };

//     const jwtClient = new google.auth.JWT(
//         key.client_email,
//         null,
//         key.private_key,
//         SCOPES,
//         null
//     );

//     const tokens = await jwtClient.authorize();
//     return tokens.access_token;
// }

// export const sendWateringNotifications = onSchedule('0 21 * * *', async (event) => {
//     try {
//         const now = Timestamp.now();
//         const userRef = db.collection('users');
//         const snapshot = await userRef.get();
//         const today = new Date(now.toDate()); // Set to midnight UTC+0
//         today.setHours(today.getHours() + 7);
//         today.setHours(0, 0, 0, 0);

//         for (const doc of snapshot.docs) {
//             const userData = doc.data();
//             const myplants = userData.myplants || [];

//             for (const myplantRef of myplants) {
//                 const plantRef = db.collection('myplants').doc(myplantRef.id);
//                 const plantDoc = await plantRef.get();

//                 if (plantDoc.exists) {
//                     const plantData = plantDoc.data();
//                     const nextSiram = plantData.nextSiram;

//                     const nextSiramDate = nextSiram.toDate();
//                     const todayDate = new Date(today);
//                     console.log(`next Siram Date: ${nextSiramDate.toDateString()}, Today Date: ${todayDate.toDateString()}`);

//                     if (nextSiramDate && nextSiramDate.getDate() === todayDate.getDate()) {
//                         const fcmToken = userData.fcmToken; // Assuming you store the user's FCM token in the user document
//                         const accessToken = await getAccessToken();

//                         const url = 'https://fcm.googleapis.com/v1/projects/rawanaman-8c43f/messages:send';

//                         const messagePayload = {
//                             message: {
//                                 token: fcmToken,
//                                 notification: {
//                                     title: "Waktunya menyiram",
//                                     body: `Waktunya menyiram tanaman ${plantData.name} anda`,
//                                 },
//                                 data: {
//                                     type: "plant"
//                                 },
//                                 android: {
//                                     priority: "high",
//                                     notification: {
//                                         channel_id: "high_importance_channel"
//                                     }
//                                 }
//                             }
//                         };

//                         const headers = {
//                             'Authorization': `Bearer ${accessToken}`,
//                             'Content-Type': 'application/json'
//                         };

//                         axios.post(
//                             url, 
//                             messagePayload, 
//                             { headers }
//                         ).then(response => {
//                             console.log('Message successfully sent:', response.data);
//                         }).catch(error => {
//                             console.error('Error sending message:', error.response ? error.response.data : error.message);
//                         })
//                     } else {
//                         console.log(`No Watering needed for plant ${plantData.name}.`)
//                     }
//                 } else {
//                     console.log(`Plant document does not exist for reference: ${plantRef.id}`);
//                 }
//             }
//         }
//     } catch (error) {
//         console.error('Error in sendWateringNotifications function:', error);
//     }
// });


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