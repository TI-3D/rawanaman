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
      future: FirebaseFirestore.instance.collection('plants').doc(documentId).get(),
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
        final String plantName = plantData.containsKey('nama') ? plantData['nama'] : 'Nama Tumbuhan';
        List<Map<String, dynamic>> listPerawatan = List<Map<String, dynamic>>.from(plantData['perawatan'] ?? []);

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
                      'Get to Know "$plantName"',
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
                      plantData['deskripsi'] ?? 'No introduction available.',
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
                      'Environments Where "$plantName" Thrives',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 13),
                    if (listPerawatan.isNotEmpty) ...[
                      for (var perawatan in listPerawatan) ...[
                        Text(
                          perawatan['jenis_perawatan'] ?? 'No title available',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          textAlign: TextAlign.justify,
                          perawatan['deskripsi'] ?? 'No description available',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16)
                      ]
                    ] else ...[
                      Text(
                        'No care instructions available.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      )
                    ],

                    // SizedBox(height: 13),
                    // Text(
                    //   'Watering & Hardiness',
                    //   style: GoogleFonts.inter(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Text(
                    //   textAlign: TextAlign.justify,
                    //   plantData['watering'] ?? 'No watering information available.',
                    //   style: GoogleFonts.inter(
                    //     fontSize: 14,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    // SizedBox(height: 16),

                    // // Ilustrasi Gambar
                    // Container(
                    //   width: double.infinity,
                    //   height: 250,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[300],
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       'Ilustrasi Gambar',
                    //       style: GoogleFonts.inter(
                    //         fontSize: 14,
                    //         color: Colors.black54,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 16),
                    // Text(
                    //   textAlign: TextAlign.justify,
                    //   plantData['environment'] ?? 'No environmental information available.',
                    //   style: GoogleFonts.inter(
                    //     fontSize: 14,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                  ],
                ),
                // Section 3
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Sunlight Condition',
                //       style: GoogleFonts.inter(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //     SizedBox(height: 8),
                //     Text(
                //       textAlign: TextAlign.justify,
                //       plantData['sunlight'] ?? 'No sunlight information available.',
                //       style: GoogleFonts.inter(
                //         fontSize: 14,
                //         color: Colors.black87,
                //       ),
                //     ),
                //     SizedBox(height: 16),

                //     // Ilustrasi Gambar
                //     Container(
                //       width: double.infinity,
                //       height: 250,
                //       decoration: BoxDecoration(
                //         color: Colors.grey[300],
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Center(
                //         child: Text(
                //           'Ilustrasi Gambar',
                //           style: GoogleFonts.inter(
                //             fontSize: 14,
                //             color: Colors.black54,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20),
                // // Section 4
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Soil Requirements',
                //       style: GoogleFonts.inter(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //     SizedBox(height: 8),
                //     Text(
                //       textAlign: TextAlign.justify,
                //       plantData['soil'] ?? 'No soil information available.',
                //       style: GoogleFonts.inter(
                //         fontSize: 14,
                //         color: Colors.black87,
                //       ),
                //     ),
                //     SizedBox(height: 16),

                //     // Ilustrasi Gambar
                //     Container(
                //       width: double.infinity,
                //       height: 250,
                //       decoration: BoxDecoration(
                //         color: Colors.grey[300],
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Center(
                //         child: Text(
                //           'Ilustrasi Gambar',
                //           style: GoogleFonts.inter(
                //             fontSize: 14,
                //             color: Colors.black54,
                //           ),
                //         ),
                //       ),
                //     ),
                //     SizedBox(height: 16),
                //     Text(
                //       textAlign: TextAlign.justify,
                //       plantData['additionalInfo'] ?? 'No additional information available.',
                //       style: GoogleFonts.inter(
                //         fontSize: 14,
                //         color: Colors.black87,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}