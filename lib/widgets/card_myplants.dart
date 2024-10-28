import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardMyPlants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3, // Number of cards
      itemBuilder: (context, index) {
        return _CardMyPlants(index: index);
      },
    );
  }
}

class _CardMyPlants extends StatelessWidget {
  final int index;
  final List<String> plantNames = ['Kuping Gajah', 'Andong', 'Lidah Mertua'];
  final List<String> plantImages = [
    'assets/images/daun_kuping_gajah.jpg', // Replace with your images
    'assets/images/andong.png',
    'assets/images/daun_lidah_mertua.jpeg'
  ];

  _CardMyPlants({required this.index});

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
                  'name': plantNames[index],
                  'image': plantImages[index],
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
                      plantImages[index], // Using network image
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
                          plantNames[index],
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Deskripsi tanaman, Lorem ipsum dolor sit amet consectetur adipiscing elit. Ipsum qui perferendis inventore iste obcaecati debitis dolorum delectus illo repellat cum at praesentium.',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          textAlign: TextAlign.justify,
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
                              index == 1
                                  ? 'Tambahkan Pengingat'
                                  : 'Every 7 Days',
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
