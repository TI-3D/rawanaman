import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardLessonDetail extends StatelessWidget {
  const CardLessonDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the arguments
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String documentId = args?['documentId'] ?? '';

    // Fetch plant data from Firestore using the document ID
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('plants').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No Plant Data Found'));
        }

        final plantData = snapshot.data!.data() as Map<String, dynamic>;
        final String plantName =
            plantData.containsKey('nama') ? plantData['nama'] : 'Nama Tumbuhan';
        final String plantImage = plantData.containsKey('image')
            ? plantData['image']
            : 'Gambar tidak ditemukan';
        List<Map<String, dynamic>> listPerawatan =
            List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);
        List<Map<String, dynamic>> listPenyakit =
            List<Map<String, dynamic>>.from(plantData['penyakit_umum'] ?? []);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              padding: EdgeInsets.fromLTRB(16, 16, 0, 5),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 16, 40, 53),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah Pengetahuanmu Tentang Tanaman $plantName',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: plantImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl:
                                  "http://mkemaln.my.id/images/$plantImage",
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: double.infinity, // Set your desired width
                            )
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
                    SizedBox(height: 20),
                  ],
                ),

                // Section 2
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Klasifikasi Tanaman $plantName',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 13),
                    Column(
                      children: [
                        _buildClassificationItem(
                            label: 'Genus',
                            value: plantData['genus'] ?? 'genus',
                            color: Color.fromRGBO(224, 224, 224, 1)),
                        _buildClassificationItem(
                            label: 'Family',
                            value: plantData['family'] ?? 'family',
                            color: Colors.white),
                        _buildClassificationItem(
                            label: 'Order',
                            value: plantData['order'] ?? 'order',
                            color: Color.fromRGBO(224, 224, 224, 1)),
                        _buildClassificationItem(
                            label: 'Class',
                            value: plantData['class'] ?? 'class',
                            color: Colors.white),
                        _buildClassificationItem(
                            label: 'Phylum',
                            value: plantData['phylum'] ?? 'phylum',
                            color: Color.fromRGBO(224, 224, 224, 1)),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),

                // Section 3
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apa yang diperlukan $plantName untuk tumbuh sehat?',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 13),
                    if (listPerawatan.isNotEmpty) ...[
                      for (var perawatan in listPerawatan) ...[
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              getIconData(perawatan['icon']),
                              color:
                                  getColorIcon(getIconData(perawatan['icon'])),
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              perawatan['jenis_perawatan'] ??
                                  'Gagal Memuat Judul',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.justify,
                          perawatan['deskripsi'] ?? 'Gagal Memuat Deskripsi',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16)
                      ]
                    ] else ...[
                      Text(
                        'Gagal Memuat Cara Perawatan',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      )
                    ],
                    SizedBox(height: 20),
                  ],
                ),

                // Section 4
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Penyakit yang $plantName sering terjangkit',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 13),
                    if (listPenyakit.isNotEmpty) ...[
                      for (var penyakit in listPenyakit) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bullet point
                            Text(
                              '• ', // Bullet character
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    penyakit['nama_penyakit'] ??
                                        'Gagal Memuat Nama Penyakit',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    textAlign: TextAlign.justify,
                                    penyakit['ciri_penyakit'] ??
                                        'Gagal Memuat Ciri Penyakit',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                    ] else ...[
                      Text(
                        'Gagal Memuat Penyakit Umum',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      )
                    ],
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClassificationItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      color: color,
      child: Row(
        children: [Text(label), Expanded(child: SizedBox()), Text(value)],
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
}
