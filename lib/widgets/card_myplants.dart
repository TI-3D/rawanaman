import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rawanaman/widgets/card_confirm_login.dart';

class CardMyPlants extends StatelessWidget {
  final List<DocumentSnapshot> plants;

  CardMyPlants({required this.plants});

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
                  final bool isReminderSet = plantRef['reminder'] ?? false;

                  return _CardMyPlants(
                      plantId: plantId,
                      myPlantDocId: myPlantDoc,
                      imageMyPlant: imageName,
                      nameMyPlant: myPlantName,
                      reminder: isReminderSet);
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
  final bool reminder;

  _CardMyPlants({
    required this.plantId,
    required this.imageMyPlant,
    required this.nameMyPlant,
    required this.myPlantDocId,
    required this.reminder,
  });

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

        // bool isReminderSet = plantData['reminder'] ?? false;

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
                      // Image Section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageMyPlant.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl:
                                    'http://mkemaln.my.id/images/$imageMyPlant',
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 100, // Set your desired width
                                height: 160, // Set your desired height
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
                      // Details Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Text(
                                      nameMyPlant,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'rename') {
                                          _renamePlant(context);
                                        } else if (value == 'delete') {
                                          _deletePlant(context);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'rename',
                                            child: Text('Rename'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
                            // Icon Pengingat
                            IconButton(
                              icon: Icon(
                                reminder
                                    ? Icons.notifications_active
                                    : Icons.notifications_none,
                                color: reminder ? Colors.green : Colors.grey,
                              ),
                              onPressed: () {
                                _showReminderDialog(
                                    context, myPlantDocId, reminder);
                              },
                            ),
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

  void _renamePlant(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: nameMyPlant);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Plant'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('myplants')
                      .doc(myPlantDocId)
                      .update({'name': newName});
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlant(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Plant'),
          content: Text(
              'Are you sure you want to delete $nameMyPlant from your collection?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('myplants')
                    .doc(myPlantDocId)
                    .delete();
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

void _showReminderDialog(
    BuildContext context, String plantId, bool currentStatus) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Set Reminder'),
        content: Text(
            'Do you want to turn reminder ${currentStatus ? 'off' : 'on'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Update reminder in Firebase
              await FirebaseFirestore.instance
                  .collection('myplants')
                  .doc(plantId)
                  .update({'reminder': !currentStatus});
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
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
