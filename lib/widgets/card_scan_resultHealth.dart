import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_button_addmyplant.dart';
import 'package:rawanaman/widgets/card_care_tips.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';
import 'package:rawanaman/widgets/card_plant_care_manual.dart';
import 'package:rawanaman/widgets/transition_bottomslide.dart';

class CardResultScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String?>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    // Get the image path from the arguments
    final String? imagePath = args?['imagePath'];
    final String? nama_doc = args?['nama'];
    final String? diseaseName = args?['healthState'];

    return FutureBuilder<DocumentSnapshot>(
        future: _fetchPlantData(nama_doc!), // Fetch data using document ID
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
                child: Text('No data found for $nama_doc')); // No data found
          }

          print("Snapshot data: ${snapshot.data}");

          // If data is found, extract it
          final plant = snapshot.data!;
          final Map<String, dynamic> plantData =
              plant.data() as Map<String, dynamic>;
          String documents = plant.id;

          String name = plantData['nama'] ?? 'Unknown Plant';
          String description =
              plantData['deskripsi'] ?? 'No description available';
          String healthState = plantData['healthState'] ?? 'Unknown';

          // data for saran perawatan
          List<Map<String, dynamic>> listPerawatan =
              List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);

          File fileUpload = File(imagePath!);

          ImageProvider imageProvider = imagePath == null
              ? AssetImage('assets/images/kuping_gajah.jpg')
              : FileImage(File(imagePath));

          return Scaffold(
            backgroundColor: Color(0xFFE0F6EF), // Background hijau
            body: SingleChildScrollView(
              // Tambahkan SingleChildScrollView di sini
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
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(context, '/main', arguments: 1);
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
                                name, // Nama tanaman
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Deskripsi: $description',
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
                                spacing: 12, // Horizontal spacing between cards
                                runSpacing:
                                    12, // Vertical spacing between rows of cards
                                children: listPerawatan.map((perawatan) {
                                  String jenis = perawatan['jenis_perawatan'] ??
                                      'Unknown Type';
                                  String icon =
                                      perawatan['icon'] ?? 'Unknown Type';
                                  String deskripsi = perawatan['deskripsi'] ??
                                      'No description available';
                                  String documentId = perawatan['imageUrl'] ??
                                      'No image available';

                                  return GestureDetector(
                                    onTap: () {
                                      // Memanggil pop-up langsung tanpa berpindah halaman
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black.withOpacity(
                                            0.5), // Latar semi-transparan
                                        builder: (BuildContext context) {
                                          return CareTipsDialog(
                                            jenis: jenis,
                                            deskripsi: deskripsi,
                                            documentId: documentId,
                                          );
                                        },
                                      );
                                    },
                                    child: _buildCareCard(
                                        getIconData(icon), jenis),
                                  );
                                }).toList(),
                              ),

                              SizedBox(height: 25),
                              // Button
                              AddMyPlantButton(
                                plantName: name.toLowerCase(),
                                diseaseName: (diseaseName ?? '').toLowerCase(),
                                imageData: fileUpload,
                              ),

                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Health State
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
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                      bottomLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(20),
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
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(14),
                                      bottomRight: Radius.circular(0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: 'Healthy',
                                      style: GoogleFonts.inter(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff10B982),
                                              letterSpacing: 0.1),
                                          fontWeight: FontWeight.w700),
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
                  // Plant Care
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(23, 0, 0, 0),
                                child: Text(
                                  'Plant Care Manual',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.fromLTRB(23, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Icon(
                                        Icons.book,
                                        color: Colors.green,
                                        size: 35,
                                      ),
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Color(0xffEEFFF9),
                                          shape: BoxShape.circle),
                                    ),
                                    SizedBox(width: 19),
                                    Expanded(
                                      child: Text(
                                        'Learn how to care for "${args?['nama'] ?? 'nama tanaman'}" step by step',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 27),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    createSlideRoute(
                                      CardLessonDetail(),
                                      {
                                        'documentId': nama_doc.toLowerCase()
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
                ],
              ),
            ),
          );
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

  Future<DocumentSnapshot> _fetchPlantData(String name) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('plants');
    // Assuming the field for the name is 'nama'
    return await collectionRef
        .doc(name)
        .get(); // Fetch document with ID 'tomat'
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
}
