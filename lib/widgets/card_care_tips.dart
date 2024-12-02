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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Sesuaikan dengan konten
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
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
            // Judul
            Center(
              child: Text(
                jenis,
                style: GoogleFonts.sourceSans3(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Deskripsi
            Text(
              deskripsi,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            // Ilustrasi Gambar dari Firebase
            FutureBuilder<String>(
              future: fetchImageUrl(documentId), // Ambil URL gambar
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Gagal Memuat Gambar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
