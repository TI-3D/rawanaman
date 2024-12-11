import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/card_confirm_login.dart';
import 'package:rawanaman/widgets/transition_fade.dart';

class CardWikiData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Jika user tidak login, langsung tampilkan dialog konfirmasi
    if (user == null) {
      Future.delayed(Duration.zero, () {
        CardConfirmLogin.showLoginDialog(context);
      });
      return Center(
        heightFactor: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You need to log in to view this content.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginPage');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff10B998), // Warna tombol hijau
                padding: EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      25), // Membuat tombol dengan sudut membulat
                ),
              ),
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
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

              final Set<String> uniquePlantIds = {};
              final List<Map<String, dynamic>> uniquePlantsList = [];

              for (var plant in plants) {
                final plantRef = plant.data() as Map<String, dynamic>;
                String plantId = plantRef['plant'].id;

                // Check if the plantId is already in the set
                if (uniquePlantIds.add(plantId)) {
                  // If it's a new plantId, add it to the uniquePlantsList
                  uniquePlantsList.add(plantRef);
                }
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: uniquePlantsList.length,
                itemBuilder: (context, index) {
                  // Fetch the plant reference from the myplants document
                  final plantRef = uniquePlantsList[index];
                  // Assuming plantRef is a reference to the plants collection
                  String plantId = plantRef['plant'].id;
                  return CardWiki(plantId: plantId);
                },
              );
            }
          },
        );
      },
    );
  }
}

class CardWiki extends StatelessWidget {
  final String plantId;

  CardWiki({required this.plantId});

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
        final String plantName = plantData['nama'] ?? 'No Name';
        final String plantImage = plantData['image'];
        final String documentId = plant.id;

        return Card(
          elevation: 4,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/plantCareManual',
                arguments: {
                  'documentId': documentId,
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: plantImage.isNotEmpty
                      ? FutureBuilder(
                          future: _getImage(plantImage),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: double.infinity,
                                color: Colors.grey[300],
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasData) {
                              return Image.file(
                                snapshot.data!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Container(
                                width: double.infinity,
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
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      plantName,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
