import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardMyPlants extends StatelessWidget {
  final List<DocumentSnapshot> plants;

  CardMyPlants({required this.plants});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          final plantReference = plant['plants'] as DocumentReference;
          final diseaseReference = plant['disease'] as DocumentReference;

          // Menggunakan FutureBuilder untuk mengambil data referensi
          return FutureBuilder(
            future: Future.wait([
              plantReference.get(), // Mengambil data dari referensi plants
              diseaseReference.get() // Mengambil data dari referensi disease
            ]),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final plantData =
                  snapshot.data![0].data() as Map<String, dynamic>;
              final diseaseData =
                  snapshot.data![1].data() as Map<String, dynamic>;

              return _CardMyPlants(
                plantName: plantData['name'] ?? "Unknown Plant",
                plantImage:
                    plantData['image'] ?? "assets/images/default_image.png",
                diseaseName: diseaseData['name'] ?? "Unknown Disease",
                reminder: plant['reminder'] ?? false,
              );
            },
          );
        },
      ),
    );
  }
}

class _CardMyPlants extends StatelessWidget {
  final String plantName;
  final String plantImage;
  final String diseaseName;
  final bool reminder;

  _CardMyPlants({
    required this.plantName,
    required this.plantImage,
    required this.diseaseName,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'name': plantName,
                  'image': plantImage,
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      plantImage, // Gambar tanaman
                      width: 100,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plantName, // Nama tanaman
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Penyakit: $diseaseName', // Penyakit tanaman
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.alarm,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              reminder
                                  ? 'Pengingat Aktif'
                                  : 'Pengingat Tidak Aktif',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
