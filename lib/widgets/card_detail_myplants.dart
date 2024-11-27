import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_care_tips.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    // Get the image path from the arguments
    final String? imagePath = args?['image'];
    final String? namaDoc = args?['name']?.toLowerCase();
    final String? diseaseName = args?['disease'];

    return FutureBuilder<DocumentSnapshot>(
        future: _fetchPlantData(namaDoc!), // Fetch data using document ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
                child: Text('No data found for $namaDoc')); // No data found
          }

          // If data is found, extract it
          Map<String, dynamic> plantData =
              snapshot.data!.data() as Map<String, dynamic>;
          String description =
              plantData['deskripsi'] ?? 'No description available';
          String healthState = plantData['healthState'] ?? 'Unknown';

          // data for saran perawatan
          List<Map<String, dynamic>> listPerawatan =
              List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);

          // ImageProvider imageProvider = imagePath == null
          //     ? AssetImage('assets/images/kuping_gajah.jpg')
          //     : FileImage(File(imagePath));

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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                args?['image'] ?? 'assets/images/default.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  args?['name'] ??
                                      'Nama Tumbuhan', // Nama tanaman
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 9),
                                Text(
                                  'a Species of Laceleaf (Anthurium)',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Common Name: Crystal Anthurium, Anthurium\n\n'
                                  'Botanical Name: Anthurium crystallinum',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 36),
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
                                  spacing:
                                      12, // Horizontal spacing between cards
                                  runSpacing:
                                      12, // Vertical spacing between rows of cards
                                  children: listPerawatan.map((perawatan) {
                                    String jenis =
                                        perawatan['jenis_perawatan'] ??
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
                                          barrierColor: Colors.black
                                              .withOpacity(
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
                                SizedBox(height: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Container(
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
                                        'Learn how to care for "${args?['name'] ?? 'nama tanaman'}" step by step',
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
                                    height: 27), // Spasi sebelum "Learn More"
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/plantCareManual',
                                      arguments: {
                                        'name': args?['name'] ?? 'Nama Tumbuhan'
                                      },
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
                  ),
                  SizedBox(height: 37),
                ],
              ),
            ),
          );
        });
  }

  // Function untuk membuat card info perawatan tanaman
  Widget _buildCareCard(IconData icon, String text) {
    return Container(
      width: 202, // Set a fixed width for consistency in layout
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
