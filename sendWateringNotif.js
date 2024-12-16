const { Timestamp } = require('@google-cloud/firestore');
const axios = require('axios');
const admin = require('firebase-admin');
const serviceAccount = require('./serviceaccount.json');

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore();


// Function to send notifications
async function sendWateringNotifications() {
    console.log("Starting sendWateringNotifications...");
    const now = Timestamp.now();
    const userRef = db.collection('users');
    const snapshot = await userRef.get();
    const today = now.toDate().setHours(0, 0, 0, 0); // Set to midnight UTC+0

    console.log(`Found ${snapshot.size} users.`);

    for (const doc of snapshot.docs) {
        const userData = doc.data();
        const myplants = userData.myplants || [];
        console.log(`Username: ${userData.username}`)

        for (const myplantRef of myplants) {
            const plantRef = db.collection('myplants').doc(myplantRef.id);
            const plantDoc = await plantRef.get();

            if (plantDoc.exists) {
                const plantData = plantDoc.data();
                const nextSiram = plantData.nextSiram;

                const nextSiramDate = nextSiram.toDate();
                const todayDate = new Date(today);
                console.log(`next Siram Date: ${nextSiramDate.toDateString()}, Today Date: ${todayDate.toDateString()}`);

                if (nextSiramDate && nextSiramDate.getDate() === todayDate.getDate()) {
                    const fcmToken = userData.fcmToken; // Assuming you store the user's FCM token in the user document
                    const accessToken = 'ya29.c.c0ASRK0GYaNIKb888lZe9M0eQuewSkKQ81dyH-yRrhUumKdPNUWle8a-KSSYW5cbP31zFvOguS_kRx_x7Qb8tP9Gh-Zb6E6HmAmlLrZYBcORCkQ0wINmwkQrw6nMseQQONDvQj0lgTJ0sgT0GumqjCeTfjknpCmQ2xiHAHIceNZhmc1sGitmT5-t5Au7GUy2OlYgpWwhZU48ToihgNgedasnF4ltjaS3QCcncc6Ve0-L_2fMkmXUPIwMKd0ecyGKxkmTGGU3GCISZM6aegoud43nvI5zvUDvUH_aPqWTu3z50aQ5fs4yD479zVtpCyS2q7Z_TovkRoD45LAeW9HVKo-Ldc-3vNMhKS2tspWH6Va2FZgGhkqB5tvplDBAN387DBgBaonfSfURgvndXyOql86vucd_UxVo8gYt4xuO141vk5bZ3Y6w8JZewlqtxhogtg4lMWsaVZ3dBfnqdkOF8c-ncmzxFURc0XRkz_JeOpI7FcseS985kldWqoe1F3IVazUe_bZYj_p6acb3Bm4_4oZ2oodkUjcw8bvsW9omOIBfFZBst41gtq23asqSaUjvrOy-oo04yj3zVqhu1plz83Jk1fIf-ocORlZQj7Bx9fdXpql41tWXyX1Mrvf-a-xpsc_oOf18yXwQX4Jf0n352t3tcZY6ze-VujYBf-Uou_I8IWw4etrU6S45YR1blS3-6sl-4gWd8dviyupkzVlIbMO8bFianZlMvMR0OXiIusvrcIbdithkm1fb-ayzcojX2OrpZx3IgS5oJIYhXvb_w_czZUtj3dac_OmXtqIYQWsh6J65Jwuf5UMpMFVU1706oyJZB_FpU32rbcSfZj4YZfJw56p79rvslor003IsqFfgfXaJqbWsUUQUV8y2fUh8zSiYRcq6MO39uqURZjupFi_lzIkIqQjf4Sem7_oJ5ju40evtS8Uv_ymOeXhW4jf9MFyb79k0hpnXosn2S8Xt1k0uUsuRc6h5uwRjF3xQsmxYx6Fz6Uu7RWw8l';

                    const url = 'https://fcm.googleapis.com/v1/projects/rawanaman-8c43f/messages:send';

                    const messagePayload = {
                        message: {
                            token: fcmToken,
                            notification: {
                                title: "Waktunya menyiram",
                                body: `Waktunya menyiram tanaman ${plantData.name} anda`,
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

                    axios.post(url, messagePayload, { headers })
                      .then(response => {
                        console.log('Message sent successfully:', response.data);
                      })
                      .catch(error => {
                        console.error('Error sending message:', error.response ? error.response.data : error.message);
                      });
                } else {
                    console.log(`No Watering needed for plant ${plantData.name}.`);
                }
            } else {
                console.log(`Plant document does not exist for reference: ${plantRef.id}`);
            }
        }
    }
}

// Export the function to be called from your Firebase Function
async function main() {
    console.log("Starting main function...");
    await sendWateringNotifications();
}

main().catch(error => {
    console.error("Error in main function:", error);
});