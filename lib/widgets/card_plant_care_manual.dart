import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';

class CardPlantCareManual extends StatefulWidget {
  const CardPlantCareManual({super.key});

  static const routeName = '/plant';

  @override
  _CardPlantCareManual createState() => _CardPlantCareManual();
}

class _CardPlantCareManual extends State<CardPlantCareManual> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the document ID from the arguments
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
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

        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Text(
                  'Learn how to care for "$plantName" step-by-step',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // Label Jumlah Lessons
                Container(
                  margin: EdgeInsets.fromLTRB(27, 13, 0, 0),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFD4F3E7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '3 Lessons',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xff10B982),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Daftar Lessons
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLessonContainer(
                          context,
                          title: 'Get to Know "$plantName"',
                          subtitle: 'Introduction',
                        ),
                        _buildLessonContainer(
                          context,
                          title: 'Environments Where "$plantName" Thrives',
                          subtitle:
                              'Watering & Hardiness\nSunlight Conditions\nSoil Requirements',
                        ),
                        _buildLessonContainer(
                          context,
                          title: 'Help! My "$plantName" Looks Sick!',
                          subtitle: 'Introduction',
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol Kembali
                Container(
                  margin: EdgeInsets.fromLTRB(44, 0, 44, 122),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: Text(
                        'Back',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 110, vertical: 12),
                        backgroundColor: Color(0xFF10B982),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonContainer(BuildContext context,
      {required String title, required String subtitle}) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final String documentId = args?['documentId'] ?? '';

    return GestureDetector(
      onTap: () {
        // Aksi yang ingin dilakukan saat Container di-tap
        Navigator.of(context).push(
          createSlideRoute(
            CardLessonDetail(),
            {'documentId': documentId}, // Kirim arguments
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(27, 0, 27, 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(1),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFD4F3E7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.book, color: Colors.green),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}

Route createSlideRoute(Widget page, Map<String, String> arguments) {
  return PageRouteBuilder(
    settings: RouteSettings(arguments: arguments), // Mengirim arguments
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Ubah slide animation agar mulai dari kanan
      final slideAnimation =
          Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );
      final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      );

      return SlideTransition(
        position: slideAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      );
    },
  );
}
