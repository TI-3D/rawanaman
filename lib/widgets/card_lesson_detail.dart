import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardLessonDetail extends StatelessWidget {
  const CardLessonDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

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
                  'Get to Know "${args?['name'] ?? 'Nama Tumbuhan'}"',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  'Introduction',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),

            // Section 2
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Environments Where "${args?['name'] ?? 'Nama Tumbuhan'}" Thrives',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  'Watering & Hardiness',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

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
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            // Section 3
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunlight Condition',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.\n\n'
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

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
            SizedBox(height: 20),
            // Section 4
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Soil Requirements',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.'
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

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
                SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.justify,
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. '
                  'Ipsum qui perferendis inventore iste obcaecati debitis doloroum '
                  'delectus illo repellat cum at praesentium.'
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
