const { initializeApp } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const { getMessaging } = require('firebase-admin/messaging');
initializeApp();
const db = getFirestore();

const frekuensiSiram = {
    'sering': 2,
    'secukupnya': 3,
};

const getPenyiramanData = (frekuensi) => {
    return frekuensiSiram[frekuensi] || 0;
};

const getTanggalSiram = (nilai, tanggal) => {
    const siramDalamHari = getPenyiramanData(nilai);
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

exports.updateNextSiram = onSchedule('every 10 minutes', async (event) => {
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
            let penyiraman = 'No frequency available'; // Default value

            for (const item of perawatan) {
                if (item.jenis_perawatan.toLowerCase() === 'air') {
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

exports.sendWateringNotifications = onSchedule('every 10 minutes', async(event) => {
    const now = Timestamp.now();
    const userRef = db.collection('users');
    const snapshot = await userRef.get();

    for (const doc of snapshot.docs){
        const userData = doc.data();
        const myplants = userData.myplants || [];

        for(const myplant of myplants){
            const plantRef = db.collection('myplants').doc(myplant);
            const plantDoc = await plantRef.get();

            if (plantDoc.exists){
                const plantData = plantDoc.data();
                const nextSiram = plantData.nextSiram;
                const reminder = plantData.reminder;

                if(nextSiram && nextSiram.toDate() == now.toDate() && reminder == true){
                    const fcmToken = userData.fcmToken;
                    const message = {
                        notification: {
                            title: 'Waktunya menyiram tanaman!',
                            body: `Waktunya menyiram tanaman ${plantData.name}`,
                        },
                        token: fcmToken,
                    };

                    try {
                        const response = await getMessaging().send(message);
                        console.log('Notification sent successfully:', response);
                    } catch (error) {
                        console.error('Error sending notification:', error);
                    }
                }
            } else {
                console.log(`Plant document does not exist for reference: ${plantRef.id}`);
            }
        }
    }

});