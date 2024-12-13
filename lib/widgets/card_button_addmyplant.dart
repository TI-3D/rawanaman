import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMyPlantButton extends StatelessWidget {
  final String plantName;
  final String diseaseName;
  final File imageData;

  AddMyPlantButton(
      {required this.plantName,
      required this.diseaseName,
      required this.imageData});

  late String fileName = imageData.uri.pathSegments.last;
  // late String fileExtension = path.extension(imageData.path);
  // String filename = '$dataId$fileExtension';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          _showConfirmationDialog(context);
        },
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            BorderSide(
                color: Color(0xff10B982), width: 1.5), // Outline warna hijau
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
                horizontal: 150, vertical: 12), // Padding di dalam tombol
          ),
          overlayColor: WidgetStateProperty.all(
            Color(0xff10B982)
                .withOpacity(0.1), // Efek klik dengan warna transparan
          ),
        ),
        child: Text(
          "Add Plant",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Color(0xff10B982), // Warna teks
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context) {
    bool reminder = false; // Nilai awal switch

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Konfirmasi',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Apakah Anda ingin diingatkan untuk penyiraman dan pemupukan?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ingatkan saya",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Switch(
                          activeColor: Color(0xff10B982),
                          inactiveThumbColor: Color(0xff10B982),
                          value: reminder,
                          onChanged: (value) {
                            // Perbarui state lokal menggunakan setState
                            setState(() {
                              reminder = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Tutup dialog
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Panggil fungsi untuk menambahkan tanaman
                            _addPlantToFirebase(reminder);
                            Navigator.of(context).pop(true); // Tutup dialog
                            Navigator.pushNamed(context, '/main',
                                arguments: 1); // Navigasi
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Color(0xff10B982),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add to My Plant',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi untuk menyimpan data ke Firebase
  void _addPlantToFirebase(bool reminder) async {
    try {
      final dataPlantsCollection =
          FirebaseFirestore.instance.collection('plants');
      final dataDiseaseCollection =
          FirebaseFirestore.instance.collection('disease');

      DocumentReference plantRef = dataPlantsCollection.doc(plantName);
      DocumentReference diseaseRef = dataDiseaseCollection.doc(diseaseName);

      DocumentSnapshot plantDoc = await plantRef.get();

      if (!plantDoc.exists) {
        print("Plant document does not exist.");
        return;
      }

      String plantNameValue = plantDoc['nama'];

      // Update the post document with the new field that contains the user reference
      final DocumentReference myPlantDocRef =
          await FirebaseFirestore.instance.collection('myplants').add({
        'name': plantNameValue,
        'plant': plantRef,
        'disease': diseaseRef,
        'reminder': reminder,
        'image': fileName,
        'created_at': Timestamp.now(),
      });

      // add data reference to current user
      _refMyPlantDataToUsers(myPlantDocRef);
      _uploadImage(imageData);

      print("Plant added successfully!");
    } catch (e) {
      print("Failed to add plant: $e");
    }
  }

  void _uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://mkemaln.my.id/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('File upload failed');
      }
    } catch (e) {
      print('No image selected, error: $e');
    }
  }

  void _refMyPlantDataToUsers(DocumentReference docRef) async {
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'myplants': FieldValue.arrayUnion([docRef])
      });

      print("My Plant data successfully append to users!");
    } catch (e) {
      print("Failed to add myPlant to user: $e");
    }
  }
}
