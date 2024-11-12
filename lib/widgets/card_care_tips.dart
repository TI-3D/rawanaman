import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCareTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    // Extract the arguments
    final String jenis = args['jenis'] ?? 'Unknown Type';
    final String deskripsi = args['deskripsi'] ?? 'No description available';

    return Scaffold(
      backgroundColor: Colors.white, // Menambahkan background putih di Scaffold
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 53),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Container(
              margin: EdgeInsets.fromLTRB(0, 83, 0, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close_outlined,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    jenis,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 34),
                  Text(
                    textAlign: TextAlign.justify,
                    deskripsi,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                      textStyle: TextStyle(
                        letterSpacing: 0.4,
                        height: 2,
                        wordSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 31),

                  // Ilustrasi Gambar
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Ilustrasi Gambar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
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
    );
  }
}
