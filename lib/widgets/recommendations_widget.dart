import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';

class RecommendationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plant Treatment Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 250,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('plants')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: double.minPositive),
                  child: Text(
                    'No Plants Available',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                // Store all plants for filtering
                List<QueryDocumentSnapshot> allPlants =
                    snapshot.data!.docs.toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(), // Animasi scroll
                  padding: EdgeInsets.only(left: 16),
                  itemCount: 5, // Use the filtered number of plants
                  itemBuilder: (context, index) {
                    if (index < 4) {
                      // Return the plant cards
                      return CardRecomendation(plant: allPlants[index]);
                    } else {
                      return Container(
                        margin: EdgeInsets.only(right: 16, bottom: 8),
                        width: 180, // Width of the card
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                              16), // Match the card's border radius
                          color: Colors
                              .transparent, // Make the Material background transparent
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                16), // Match the card's border radius
                            onTap: () {
                              Navigator.pushNamed(context, '/main',
                                  arguments: 3);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'More',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20, // Larger font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class CardRecomendation extends StatelessWidget {
  final QueryDocumentSnapshot plant;

  CardRecomendation({required this.plant});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> plantData = plant.data() as Map<String, dynamic>;
    final String plantImage = plantData.containsKey('image')
        ? plant['image']
        : 'Failed to retrieve the image';

    return Container(
      margin: EdgeInsets.only(right: 16, bottom: 8),
      width: 180, // Width of the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        borderRadius:
            BorderRadius.circular(16), // Match the card's border radius
        color: Colors.transparent, // Make the Material background transparent
        child: InkWell(
          borderRadius:
              BorderRadius.circular(16), // Match the card's border radius
          onTap: () {
            Navigator.of(context).push(
              createSlideRoute(
                CardLessonDetail(),
                {'documentId': plant.id}, // Send arguments
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Add border radius to the image
                child: plantImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: 'https://mkemaln.my.id/images/$plantImage',
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 160, // Set your desired width
                        height: 160, // Set your desired height
                      )
                    : Container(
                        width: 160,
                        height: 160,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 8),
              Text(
                plantData['nama'] ?? 'no data',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, // Larger font size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B982)),
              ),
              SizedBox(height: 4),
              Text(
                plantData['nama_latin'] ?? 'no data',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
