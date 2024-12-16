import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareTipsDialog extends StatelessWidget {
  final String jenis;
  final String deskripsi;
  final String documentId; // ID dokumen di Firestore

  const CareTipsDialog({
    Key? key,
    required this.jenis,
    required this.deskripsi,
    required this.documentId,
  }) : super(key: key);

  Future<String> fetchImageUrl(String documentId) async {
    // Mengambil URL gambar dari Firestore
    final doc = await FirebaseFirestore.instance
        .collection('plants') // Ganti dengan koleksi Firestore Anda
        .doc(documentId)
        .get();

    return doc['imageUrl']; // Pastikan 'imageUrl' ada di dokumen
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Menentukan ukuran teks tetap yang tidak berubah di perangkat web dan mobile
    final double titleFontSize = 30; // Ukuran teks tetap untuk judul
    final double descriptionFontSize = 14; // Ukuran teks tetap untuk deskripsi
    final double iconSize = 28; // Ukuran teks tetap untuk deskripsi

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1,
        vertical: screenHeight * 0.1,
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Close
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  icon: Icon(
                    Icons.close_outlined,
                    size: iconSize,
                    color: Colors.black,
                  ),
                ),
              ),
              // Judul
              Center(
                child: Text(
                  jenis,
                  style: GoogleFonts.sourceSans3(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Deskripsi
              Center(
                child: Text(
                  deskripsi,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: descriptionFontSize,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Ilustrasi Gambar dari Firebase
              FutureBuilder<String>(
                future: fetchImageUrl(documentId), // Ambil URL gambar
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Gagal Memuat Gambar',
                            style: GoogleFonts.inter(
                              fontSize: descriptionFontSize,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
