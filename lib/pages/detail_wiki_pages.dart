import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';

class DetailWikiPage extends StatefulWidget {
  const DetailWikiPage({super.key});

  static const routeName = '/plant';

  @override
  _DetailWikiPage createState() => _DetailWikiPage();
}

class _DetailWikiPage extends State<DetailWikiPage> {
  @override
  Widget build(BuildContext context) {
    // Ambil Argument dari page sebelumnya
    final Map<String, String>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return Scaffold(
      backgroundColor: Colors.white, // Menambahkan background putih di Scaffold
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100), // Menambahkan jarak dari atas layar
            // Judul Utama
            Text(
              'Learn how to care for "${args?['name'] ?? 'Nama Tumbuhan'}" step-by-step',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black,
                  textStyle: TextStyle()),
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
                      title:
                          'Get to Know "${args?['name'] ?? 'Nama Tumbuhan'}"',
                      subtitle: 'Introduction',
                    ),
                    _buildLessonContainer(
                      context,
                      title:
                          'Environments Where "${args?['name'] ?? 'Nama Tumbuhan'}" Thrives',
                      subtitle:
                          'Watering & Hardiness\nSunlight Conditions\nSoil Requirements',
                    ),
                    _buildLessonContainer(
                      context,
                      title:
                          'Help! My "${args?['name'] ?? 'Nama Tumbuhan'}" Looks Sick!',
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
                            letterSpacing: 0.3)),
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
  }

  Widget _buildLessonCard(BuildContext context,
      {required String title, required String subtitle}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFD4F3E7),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.book, color: Colors.green),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black26),
        onTap: () {
          // Tambahkan navigasi atau aksi lainnya jika diperlukan
        },
      ),
    );
  }
}

Widget _buildLessonContainer(BuildContext context,
    {required String title, required String subtitle}) {
  final Map<String, String>? args =
      ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
  return GestureDetector(
    onTap: () {
      // Aksi yang ingin dilakukan saat Container di-tap
      // Navigator.pushNamed(context, '/lessonDetail',
      //     arguments: {'name': args?['name'] ?? 'Nama Tumbuhan'});
      Navigator.of(context).push(
        createFadeRoute(
          CardLessonDetail(),
          {'name': args?['name'] ?? 'Nama Tumbuhan'}, // Kirim arguments
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

Route createFadeRoute(Widget page, Map<String, String> arguments) {
  return PageRouteBuilder(
    settings: RouteSettings(arguments: arguments), // Mengirim arguments
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
