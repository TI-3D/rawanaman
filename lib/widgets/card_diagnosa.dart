import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/navbar.dart';

class CardDiagnosa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/kuping_gajah.jpg'),
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
                      Navigator.pushNamed(context, '/');
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
                          args?['name'] ?? 'Nama Tumbuhan', // Nama tanaman
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
                        SizedBox(height: 34),
                        Text(
                          'How to cure?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        CureStep(
                          title: 'Isolate Infected Plants',
                          description:
                              'Remove and destroy any severely infected plants to prevent the spread of the fungus.',
                        ),
                        CureStep(
                          title: 'Avoid Overhead Watering',
                          description:
                              'Water plants at the base to avoid wetting the leaves, as wet leaves provide a favorable environment for fungal growth.',
                        ),
                        CureStep(
                          title: 'Monitor for Recurrence',
                          description:
                              'Keep a close eye on your plants for signs of late blight, and take immediate action if you notice any symptoms.',
                        ),
                        SizedBox(height: 34),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  '/addPlant'); //ini nanti ke page my plant
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Color(0xff10B982), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 132, vertical: 14),
                            ),
                            child: Text(
                              'Add Plant',
                              style: TextStyle(
                                color: Color(0xff10B982),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
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
            Icons.circle_outlined,
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
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
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
