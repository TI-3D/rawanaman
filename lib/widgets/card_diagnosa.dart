import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rawanaman/widgets/card_button_rediagnose.dart';
import 'package:rawanaman/models/gemini2.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDiagnosa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String?>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    final String myPlantId = args!['myplantid']!;
    final String? imagePath = args['imagePath'];
    final String diseaseName = args['healthState']!;
    final String rediagnose = args['rediagnose']!;

    return FutureBuilder<DocumentSnapshot>(
      future: _fetchDiseaseData(diseaseName),
      builder: (context, snapshot) {
        // Check if the future is still loading
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: CircularProgressIndicator());
        // }

        // // Check for errors
        // if (snapshot.hasError) {
        //   return Center(child: Text('Error: ${snapshot.error}'));
        // }

        // // Check if data exists
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text(''));
        }

        Map<String, dynamic> diseaseData =
            snapshot.data!.data() as Map<String, dynamic>;
        String description =
            diseaseData['deskripsi'] ?? 'No description available';
        // String healthState = diseaseData['healthState'] ?? 'Unknown';

        // data for saran perawatan
        List<Map<String, dynamic>> listPerawatan =
            List<Map<String, dynamic>>.from(diseaseData['perawatan'] ?? []);

        File? imageFile = imagePath != null ? File(imagePath) : null;

        ImageProvider imageProvider = imagePath == null
            ? AssetImage('assets/images/kuping_gajah.jpg')
            : FileImage(File(imagePath));

        return Scaffold(
          backgroundColor: Color(0xFFE0F6EF), // Background hijau
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    // Gambar tanaman di bagian atas
                    Container(
                      width: double.infinity,
                      height: 350.0, // Atur tinggi gambar
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Tombol back
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          rediagnose == 'true'
                              ? Navigator.popUntil(context,
                                  (route) => route.settings.name == '/detail')
                              : Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    // Card yang menutupi sisa layar di bawah gambar
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 295, 0, 0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              args?['healthState'] ?? 'Unknown', // Nama tanaman
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(162, 252, 249, 169)),
                              child: Text(
                                "Disclaimer: All the result below was generated by Gemini AI and may not be 100% accurate ⚠️",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Description: $description',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            rediagnose == 'true'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            rediagnose == 'true'
                                ? CardButtonRediagnose(
                                    myPlantId: myPlantId,
                                    diseaseName:
                                        (diseaseName ?? '').toLowerCase(),
                                    imageData: imageFile,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            SizedBox(height: 34),
                            Text(
                              'How to cure?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: listPerawatan.map((step) {
                                return CureStep(
                                  title: step['jenis_perawatan'] ?? 'Unknown',
                                  description: step['deskripsi'] ?? 'Unknown',
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 114),
                          ],
                        ),
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
  }
}

Future<DocumentSnapshot> _fetchDiseaseData(String name) async {
  name = name.toLowerCase();

  print('start identifying disease image $name');
  await generateAndSaveText2(name);
  print('finish identify disease');

  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('disease');
  // Assuming the field for the name is 'nama'
  return await collectionRef.doc(name).get(); // Fetch document with ID 'tomat'
}

class CureStep extends StatelessWidget {
  final String title;
  final String description;

  CureStep({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            color: Color(0xff10B982),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  textAlign: TextAlign.justify,
                  description,
                  style: GoogleFonts.sourceSans3(
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.09),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
