import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';

class DetailMyPlant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String?>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;
    final String documentId = args?['documentId'] ?? '';
    final String myPlantDoc = args?['myPlantDoc'] ?? '';

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('myplants')
            .doc(myPlantDoc)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error While Fetching MyPlant Data: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(''));
          }

          final myPlantData = snapshot.data!.data() as Map<String, dynamic>;
          final String myPlantName = myPlantData['name'];
          final String myPlantImage = myPlantData['image'];
          final DocumentReference diseaseData = myPlantData['disease'];
          final Timestamp lastTimeScanned = myPlantData['lastTimeScanned'];
          final DateTime lastTimeScannedDate = lastTimeScanned.toDate();
          final String lastTimeScannedString =
              DateFormat('dd-MM-yyyy').format(lastTimeScannedDate);

          return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('plants')
                  .doc(documentId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No Plant Data Found'));
                }

                final plantData = snapshot.data!.data() as Map<String, dynamic>;
                final String plantName = plantData.containsKey('nama')
                    ? plantData['nama']
                    : 'Nama Tumbuhan';
                // final String? plantImage =
                //     plantData.containsKey('image') ? plantData['image'] : null;

                List<Map<String, dynamic>> listPerawatan =
                    List<Map<String, dynamic>>.from(
                        plantData['perawatan'] ?? []);

                return Scaffold(
                  backgroundColor: Color(0xFFE0F6EF), //background hijau
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Gambar tanaman di bagian atas
                            Container(
                                width: double.infinity,
                                height: 300.0, // Atur tinggi gambar
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                child: myPlantImage.isEmpty
                                    ? Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.white,
                                          size: 64,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "https://mkemaln.my.id/images/$myPlantImage",
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        width: double
                                            .infinity, // Set your desired width
                                      )),
                            //tombol back
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 178, 0, 0),
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
                                  Navigator.pop(context);
                                },
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.black),
                              ),
                            ),
                            // Card yang menutupi sisa layar di bawah gambar
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 265, 0, 0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16),
                                      Text(
                                        myPlantName, // Nama tanaman
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 36),
                                      Text(
                                        plantData['deskripsi'] ??
                                            'No description available.',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 27),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 12,
                                        runSpacing: 6,
                                        children:
                                            listPerawatan.map((perawatan) {
                                          String jenis =
                                              perawatan['jenis_perawatan'] ??
                                                  'Unknown Type';
                                          String icon = perawatan['icon'] ??
                                              'Unknown Type';
                                          String deskripsi =
                                              perawatan['deskripsi'] ??
                                                  'No description available.';

                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(jenis),
                                                    content: Row(children: [
                                                      Icon(
                                                        getIconData(icon),
                                                        color: getColorIcon(
                                                            getIconData(icon)),
                                                        size: 40,
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Text(
                                                          deskripsi,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: _buildCareCard(
                                                getIconData(icon), jenis),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        myPlantData['disease'] != 'Healthy'
                            ? Container(
                                width: 473,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(14, 9, 14, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF10B982)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 0),
                                              child: Text(
                                                'Health State',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.5),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 30),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFFCEE),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/plant.svg',
                                                    height: 45,
                                                    width: 45,
                                                    color: Color(0xffFFB200),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFB200),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(2),
                                                      bottomLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(14),
                                                      bottomRight:
                                                          Radius.circular(0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Bad',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        letterSpacing: 0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Your plant's ",
                                                    style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            letterSpacing: 0.3),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  TextSpan(
                                                    text: 'Sick',
                                                    style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xffFFB200),
                                                            letterSpacing: 0.3),
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  TextSpan(
                                                    text: " before",
                                                    style: GoogleFonts.inter(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            letterSpacing: 0.3),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 9),
                                            Text(
                                              "Last time Scanned :",
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Text(
                                              lastTimeScannedString,
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            SizedBox(height: 9),
                                            FutureBuilder(
                                                future: diseaseData.get(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData ||
                                                      !snapshot.data!.exists) {
                                                    return Center(
                                                        child: Text(''));
                                                  }

                                                  final diseaseData = snapshot
                                                          .data!
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  final diseaseName =
                                                      diseaseData['nama'];

                                                  return Text(
                                                    "Diagnose: $diseaseName",
                                                    style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  );
                                                }),

                                            // Container(
                                            //   margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                                            //   child: GestureDetector(
                                            //     onTap: () {
                                            //       Navigator.pushNamed(
                                            //           context, '/diagnoseResult',
                                            //           arguments: <String, String?>{
                                            //             'healthState': diseaseName,
                                            //             'imagePath': imagePath,
                                            //           });
                                            //     },
                                            //     child: Align(
                                            //       alignment: Alignment.center,
                                            //       child: Text(
                                            //         'Diagnose >',
                                            //         style: GoogleFonts.poppins(
                                            //           textStyle: TextStyle(
                                            //             fontSize: 14,
                                            //             color: Colors.green,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 14,
                                    // ),
                                    // FutureBuilder(
                                    //     future: diseaseData.get(),
                                    //     builder: (context, snapshot) {
                                    //       if (!snapshot.hasData ||
                                    //           !snapshot.data!.exists) {
                                    //         return Center(child: Text(''));
                                    //       }

                                    //       final diseaseData = snapshot.data!
                                    //           .data() as Map<String, dynamic>;
                                    //       final diseaseName =
                                    //           diseaseData['nama'];

                                    //       List<Map<String, dynamic>>
                                    //           listPerawatan =
                                    //           List<Map<String, dynamic>>.from(
                                    //               diseaseData['perawatan'] ??
                                    //                   []);

                                    //       return Column(
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.start,
                                    //         children: [
                                    //           Text(
                                    //             "Diagnosed: $diseaseName",
                                    //             style: GoogleFonts.inter(
                                    //               textStyle: TextStyle(
                                    //                   fontSize: 16,
                                    //                   color: Colors.black,
                                    //                   fontWeight:
                                    //                       FontWeight.w700),
                                    //             ),
                                    //           ),
                                    //           SizedBox(
                                    //             height: 8,
                                    //           ),
                                    //           Text(
                                    //             'How to cure?',
                                    //             style: TextStyle(
                                    //               fontSize: 16,
                                    //               fontWeight: FontWeight.bold,
                                    //             ),
                                    //           ),
                                    //           SizedBox(height: 6),
                                    //           Column(
                                    //             children:
                                    //                 listPerawatan.map((step) {
                                    //               return CureStep(
                                    //                 title: step[
                                    //                         'jenis_perawatan'] ??
                                    //                     'Unknown',
                                    //                 description:
                                    //                     step['deskripsi'] ??
                                    //                         'Unknown',
                                    //               );
                                    //             }).toList(),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     }),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/cameraPageDiagnose',
                                              arguments: myPlantDoc);
                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Diagnose again >',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                width: 473,
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.fromLTRB(14, 9, 14, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF10B982)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Text(
                                            'Health State',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 30),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEEFFF9),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                  topRight: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/svgs/plant.svg',
                                                height: 45,
                                                width: 45,
                                                color: Color(0xff10B982),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF10B982),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(2),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  topRight: Radius.circular(14),
                                                  bottomRight:
                                                      Radius.circular(0),
                                                ),
                                              ),
                                              child: Text(
                                                'Good',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'This plant looks ',
                                                  style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          letterSpacing: 0.1),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: 'Healthy',
                                                  style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xff10B982),
                                                          letterSpacing: 0.1),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 9),
                                          Text(
                                            "Your plant's Good!",
                                            style: GoogleFonts.inter(
                                              textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          width: 473,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.fromLTRB(14, 9, 14, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF10B982)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              // Plant Course
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Plant Care Manual',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            8), // Spasi antara judul dan ikon+teks
                                    Row(
                                      children: [
                                        Icon(Icons.book, color: Colors.green),
                                        SizedBox(
                                            width:
                                                16), // Spasi antara ikon dan teks deskripsi
                                        Expanded(
                                          child: Text(
                                            'Learn how to care for "${plantName ?? 'nama tanaman'}" step by step',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            27), // Spasi sebelum "Learn More"
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          createSlideRoute(
                                            CardLessonDetail(),
                                            {
                                              'documentId': documentId
                                            }, // Kirim arguments
                                          ),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Learn More >',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 37),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  // Function untuk membuat card info perawatan tanaman
  Widget _buildCareCard(IconData icon, String text) {
    return Container(
      width: 181, // Set a fixed width for consistency in layout
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF2FFFB), // Light green background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2), // Slight shadow for depth
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: getColorIcon(icon),
            size: 28, // Slightly larger icon
          ),
          SizedBox(width: 11), // Space between icon and text
          Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center, // Center-align text
          ),
        ],
      ),
    );
  }

  static Map<String, IconData> iconMap = {
    'Icons.sunny': Icons.sunny,
    'Icons.water_drop': Icons.water_drop,
    'Icons.health_and_safety': Icons.health_and_safety,
    'Icons.cut': Icons.cut,
    // Add more mappings as needed
  };

  static Map<IconData, Color> colorIcon = {
    Icons.sunny: Colors.yellow,
    Icons.water_drop: Colors.blue,
    Icons.health_and_safety: Colors.green,
    Icons.cut: Colors.black,
    // Add more mappings as needed
  };

  // Function to get IconData from string
  IconData getIconData(String iconString) {
    return iconMap[iconString] ?? Icons.help; // Default icon if not found
  }

  // Function to get ColorData from string
  Color getColorIcon(IconData iconColor) {
    return colorIcon[iconColor] ?? Colors.black; // Default icon if not found
  }

  Future<String> getDiseaseName(DocumentReference ref) async {
    try {
      // Get the document snapshot
      DocumentSnapshot snapshot = await ref.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Return the 'nama' field
        return snapshot.get('nama') as String;
      } else {
        // Document does not exist
        return 'Failed to get disease name';
      }
    } catch (e) {
      // Handle any errors
      print('Error getting disease name: $e');
      return 'Failed to get disease name';
    }
  }
}

class CureStep extends StatelessWidget {
  final String title;
  final String description;

  CureStep({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children at the start
        children: [
          Column(
            children: [
              SizedBox(
                height: 4,
              ),
              Icon(
                Icons.circle,
                color: Color(0xff10B982),
                size: 10,
              ),
            ],
          ),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 2), // Add a small space if needed
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.sourceSans3(
                    textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.04,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
