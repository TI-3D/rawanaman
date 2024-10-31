import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardFullSunCare extends StatelessWidget {
  const CardFullSunCare({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Partial Sun',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 34),
                  Text(
                    textAlign: TextAlign.justify,
                    'Tanaman giok "Hobbit" paling cocok ditanam pada posisi terkena sinar matahari penuh, sinar matahari yang cukup dapat membuatnya lebih sehat dan cerah. Sinar matahari penuh mengacu pada paparan sinar matahari langsung lebih dari 6 jam per hari, biasanya melalui jendela yang menghadap ke selatan (belahan bumi utara) atau tempat di halaman yang terkena sinar matahari langsung sepanjang hari.',
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
