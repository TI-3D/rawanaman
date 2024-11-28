import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardMyPlants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('User  not logged in'));
    }

    // Fetch the user's document to get the myplants array
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Center(child: Text('User  data not found'));
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final List<dynamic> myPlants = userData['myplants'] ?? [];

        if (myPlants.isEmpty) {
          return Center(child: Text('No plants in your collection'));
        }

        // Fetch the plants based on the myplants references
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('myplants')
              .where(FieldPath.documentId, whereIn: myPlants)
              .snapshots(),
          builder: (context, plantsSnapshot) {
            if (plantsSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!plantsSnapshot.hasData || plantsSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Plants Available'));
            } else {
              final plants = plantsSnapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plantRef = plants[index].data() as Map<String, dynamic>;
                  final plantId = plantRef['plant'].id;

                  return _CardMyPlants(plantId: plantId);
                },
              );
            }
          },
        );
      },
    );
  }
}

class _CardMyPlants extends StatelessWidget {
  final String plantId;

  _CardMyPlants({required this.plantId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('plants')
          .doc(plantId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Plant not found'));
        }

        final plant = snapshot.data!;
        final Map<String, dynamic> plantData = plant.data() as Map<String, dynamic>;
        final String plantName = plantData['nama'] ?? 'No Name';
        final String? plantImage = plantData['image'];
        List<Map<String, dynamic>> listPerawatan =
              List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);
        String penyiraman = 'No frequency available'; // Default value
        for (var perawatan in listPerawatan) {
          if (perawatan['jenis_perawatan'] == 'air' || perawatan['jenis_perawatan'] == 'Air') {
            penyiraman = perawatan['nilai'] as String? ?? penyiraman; // Update frequency if found
            break; // Exit the loop since we found the entry
          }
        }

        return Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: {
                      'documentId': plant.id,
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: plantImage != null && plantImage.isNotEmpty
                            ? Image.asset(
                                plantImage,
                                width: 100,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 100,
                                height: 160,
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plantName,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              plantData['deskripsi'] ?? 'No description available.',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.alarm,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  penyiraman,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
