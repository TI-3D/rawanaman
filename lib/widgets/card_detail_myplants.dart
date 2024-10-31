import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/navbar.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

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
                  height: 350.0, // Atur tinggi gambar
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/daun_kuping_gajah.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //tombol back
                Container(
                  margin: EdgeInsets.fromLTRB(0, 130, 0, 0),
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
                Stack(
                  children: [],
                ),
                // Card yang menutupi sisa layar di bawah gambar
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 295, 0, 0),
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
                            args?['name'] ?? 'Nama Tumbuhan', // Nama tanaman
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
                            'Deskripsi: Lorem ipsum dolor sit amet consectetur adipiscing elit. '
                            'Ipsum qui perferendis inventore iste obcaecati debitis dolorum delectus '
                            'illo repellat cum at praesentium.',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 27),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        '/fullSunCare'); // Route untuk Full Sun
                                  },
                                  child: _buildCareCard(
                                      Icons.wb_sunny, 'Full Sun'),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        '/mediumCare'); // Route untuk Medium
                                  },
                                  child: _buildCareCard(
                                      Icons.wb_sunny_outlined, 'Medium'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
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
                              height: 8), // Spasi antara judul dan ikon+teks
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
                          SizedBox(height: 27), // Spasi sebelum "Learn More"
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/plantCareManual');
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
                              height: 8), // Spasi antara judul dan ikon+teks
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
                          SizedBox(height: 27), // Spasi sebelum "Learn More"
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/plantCareManual');
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
          ],
        ),
      ),
    );
  }

  // Function untuk membuat card info perawatan tanaman
  Widget _buildCareCard(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF2FFFB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.yellow),
            SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
