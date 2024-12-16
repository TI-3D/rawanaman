import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/service/notification_service.dart';

class CardMyPlants extends StatefulWidget {
  final List<DocumentSnapshot> plants;

  CardMyPlants({required this.plants});

  @override
  State<CardMyPlants> createState() => _CardMyPlantsState();
}

class _CardMyPlantsState extends State<CardMyPlants> {
  Future<void> setupPushNotification() async {
    await NotificationService.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    setupPushNotification();
  }

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
                  final myPlantDoc = plants[index].id;
                  final plantRef = plants[index].data() as Map<String, dynamic>;
                  final plantId = plantRef['plant'].id;
                  final imageName = plantRef['image'] ?? '';
                  final myPlantName = plantRef['name'] ?? 'Unknown';
                  final createdAt = plantRef['created_at'] ?? Timestamp.now();
                  final siramAt = plantRef['nextSiram'] ?? createdAt;

                  return _CardMyPlants(
                    plantId: plantId,
                    myPlantDocId: myPlantDoc,
                    imageMyPlant: imageName,
                    nameMyPlant: myPlantName,
                    createdMyPlant: createdAt,
                    siramMyPlant: siramAt,
                  );
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
  final String imageMyPlant;
  final String nameMyPlant;
  final String myPlantDocId;
  final Timestamp createdMyPlant;
  Timestamp siramMyPlant;

  _CardMyPlants(
      {required this.plantId,
      required this.imageMyPlant,
      required this.nameMyPlant,
      required this.myPlantDocId,
      required this.createdMyPlant,
      required this.siramMyPlant});

  Future<void> _updateNextSiram(int penyiraman, BuildContext context) async {
    if (siramMyPlant == createdMyPlant) {
      siramMyPlant = getTanggalSiram(penyiraman, createdMyPlant);
      await FirebaseFirestore.instance
          .collection('myplants')
          .doc(myPlantDocId)
          .set({
        'nextSiram': siramMyPlant,
      }, SetOptions(merge: true));
    }
  }

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
        final Map<String, dynamic> plantData =
            plant.data() as Map<String, dynamic>;
        // final String plantName = plantData['nama'] ?? 'No Name';
        // final String? plantImage = plantData['image'];
        List<Map<String, dynamic>> listPerawatan =
            List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);
        int penyiraman = 0; // Default value
        for (var perawatan in listPerawatan) {
          if (perawatan['jenis_perawatan'] == 'watering' ||
              perawatan['jenis_perawatan'] == 'Watering') {
            penyiraman = perawatan['nilai'] ??
                penyiraman; // Update frequency if found
            break; // Exit the loop since we found the entry
          }
        }

        _updateNextSiram(penyiraman, context);

        int hariSampaiSiram =
            (siramMyPlant.toDate().difference(DateTime.now()).inDays);
        String pesanSiram = hariSampaiSiram > 0
            ? 'Siram dalam $hariSampaiSiram hari lagi'
            : 'Siram hari ini';

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
                      'myPlantDoc': myPlantDocId,
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
                        child: imageMyPlant != null && imageMyPlant.isNotEmpty
                            ? FutureBuilder(
                                future: _getImage(imageMyPlant),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 100,
                                      height: 160,
                                      color: Colors.grey[300],
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasData) {
                                    // Display the image if the file is retrieved successfully
                                    return Image.file(
                                      snapshot.data!,
                                      width: 100,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    );
                                  } else {
                                    return Container(
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
                                    );
                                  }
                                })
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
                              nameMyPlant,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              plantData['deskripsi'] ??
                                  'No description available.',
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
                                  pesanSiram,
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



  Timestamp getTanggalSiram(int nilai, Timestamp tanggal) {
    int siramDalamHari = nilai;

    DateTime lastWateredDate = tanggal.toDate();
    DateTime nextWateringDate =
        lastWateredDate.add(Duration(days: siramDalamHari));

    return Timestamp.fromDate(nextWateringDate);
  }
}

Future<File> _getImage(String filename) async {
  try {
    var response =
        await http.get(Uri.parse('http://mkemaln.my.id/images/$filename'));

    if (response.statusCode == 200) {
      // Create a file from the response body
      final bytes = response.bodyBytes;
      final dir = await Directory.systemTemp.createTemp();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Failed to load image');
    }
  } catch (e) {
    print('Error fetching image: $e');
    rethrow;
  }
}
