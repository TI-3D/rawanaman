import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/transition_fade.dart';

class CardWikiData2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('plants').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: double.minPositive),
            child: Text(
              'No Plants Available',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 18),
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        } else {
          final plants = snapshot.data!.docs;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: plants.length, // Use the actual number of plants
            itemBuilder: (context, index) {
              return CardWiki2(plant: plants[index]);
            },
          );
        }
      }
    );
  }
}

class CardWiki2 extends StatelessWidget {
  final QueryDocumentSnapshot plant;

  CardWiki2({required this.plant});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> plantData = plant.data() as Map<String, dynamic>;
    final String plantName = plantData.containsKey('nama') ? plant['nama'] : 'No Name';
    final String? plantImage = plantData.containsKey('image') ? plant['image'] : null;
    final String documentId = plant.id;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // Buat lingkaran pada Card
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/plantCareManual',
            arguments:{
              'documentId': documentId,
            },
          );
        },
        child: Stack(
          alignment: Alignment.center, // Pusatkan konten di tengah
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: plantImage != null && plantImage.isNotEmpty
                  ? Image.asset(
                      plantImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Handle the error if the image is not found
                        return Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  )
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  plantName,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
