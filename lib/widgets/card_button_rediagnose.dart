import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardButtonRediagnose extends StatelessWidget {
  final String myPlantId;
  final String diseaseName;
  final File? imageData;

  CardButtonRediagnose(
      {required this.myPlantId,
      required this.diseaseName,
      required this.imageData});

  late String fileName = imageData!.uri.pathSegments.last;
  // late String fileExtension = path.extension(imageData.path);
  // String filename = '$dataId$fileExtension';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
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
                horizontal: isSmallScreen ? 120 : 140,
                vertical: 12), // Padding di dalam tombol
          ),
          overlayColor: WidgetStateProperty.all(
            Color(0xff10B982)
                .withOpacity(0.1), // Efek klik dengan warna transparan
          ),
        ),
        child: Text(
          "Submit Diagnose",
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
                      'Confirmation',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Do you want to submit the new diagnose result?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
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
                            _updateDiseaseToFirebase();
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(context, '/main', arguments: 1);
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
                            'Submit',
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
  void _updateDiseaseToFirebase() async {
    try {
      print("myPlantId: $myPlantId"); // Debugging line
      print("diseaseName: $diseaseName");
      final dataPlantsCollection =
          FirebaseFirestore.instance.collection('myplants');
      final dataDiseaseCollection =
          FirebaseFirestore.instance.collection('disease');

      DocumentReference plantRef = dataPlantsCollection.doc(myPlantId);
      DocumentReference diseaseRef =
          dataDiseaseCollection.doc(diseaseName.toLowerCase());

      await plantRef.update({
        'disease': diseaseRef,
        'image': fileName,
        'lastTimeScanned': Timestamp.now()
      });

      _uploadImage(imageData!);

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
}
