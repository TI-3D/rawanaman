import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';
import 'package:rawanaman/widgets/transition_fade.dart';

class CardWikiData2 extends StatefulWidget {
  @override
  _CardWikiData2State createState() => _CardWikiData2State();
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('plants').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }

  //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //           return Container(
  //             margin: const EdgeInsets.symmetric(vertical: double.minPositive),
  //             child: Text(
  //               'No Plants Available',
  //               style: GoogleFonts.poppins(
  //                 textStyle: TextStyle(fontSize: 18),
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           );
  //         } else {
  //           final plants = snapshot.data!.docs;
  //           return ListView.builder(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             // scrollDirection: ,
  //             itemCount: plants.length, // Use the actual number of plants
  //             itemBuilder: (context, index) {
  //               return CardWiki2(plant: plants[index]);
  //             },
  //           );
  //         }
  //       });
  // }
}

class _CardWikiData2State extends State<CardWikiData2> {
  String searchQuery = '';
  List<QueryDocumentSnapshot> allPlants = [];
  List<QueryDocumentSnapshot> filteredPlants = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
              filteredPlants = allPlants.where((plant) {
                final plantData = plant.data() as Map<String, dynamic>;
                final plantName = plantData['nama'].toString().toLowerCase();
                return plantName.contains(searchQuery);
              }).toList();
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Color.fromRGBO(16, 185, 130, 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 185, 130, 1.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 185, 130, 1.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 185, 130, 1.0),
              ),
            ),
            hintText: 'Search',
            hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 14, letterSpacing: 0.3)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('plants').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: double.minPositive),
                child: Text(
                  'No Plants Available',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 18),
                    fontWeight: FontWeight.bold,
                    // color: Colors.grey,
                  ),
                ),
              );
            } else {
              // Store all plants for filtering
              allPlants = snapshot.data!.docs;
              filteredPlants = allPlants.where((plant) {
                final plantData = plant.data() as Map<String, dynamic>;
                final plantName = plantData['nama'].toString().toLowerCase();
                return plantName.contains(searchQuery);
              }).toList();

              if (filteredPlants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: double.minPositive),
                        child: Text(
                          'Tidak ada Tanaman Dengan Nama Tersebut',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 18,
                            ),
                            // fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color.fromARGB(255, 78, 77, 77),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount:
                    filteredPlants.length, // Use the filtered number of plants
                itemBuilder: (context, index) {
                  return CardWiki2(plant: filteredPlants[index]);
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class CardWiki2 extends StatelessWidget {
  final QueryDocumentSnapshot plant;

  CardWiki2({required this.plant});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> plantData = plant.data() as Map<String, dynamic>;
    final String plantName =
        plantData.containsKey('nama') ? plant['nama'] : 'No Name';
    final String plantLatinName = plantData.containsKey('nama_latin')
        ? plant['nama_latin']
        : 'No Latin Name';
    final String plantImage =
        plantData.containsKey('image') ? plant['image'] : null;
    final String documentId = plant.id;

    return Column(
      children: [
        GestureDetector(
          // elevation: 4,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                createSlideRoute(
                  CardLessonDetail(),
                  {'documentId': documentId}, // Kirim arguments
                ),
              );
            },
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align vertically
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  child: plantImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: 'http://mkemaln.my.id/images/$plantImage',
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 100, // Set your desired width
                          height: 100, // Set your desired height
                        )
                      : Container(
                          width: 80,
                          height: 80,
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
                SizedBox(width: 16), // Add space between image and text
                Expanded(
                  // Use Expanded to take up remaining space
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0), // Add vertical padding
                        child: Text(
                          plantName,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold, // Make the plant name bold
                            ),
                          ),
                        ),
                      ),
                      Text(
                        plantLatinName,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize:
                                16, // Slightly smaller font size for Latin name
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios, // Use an arrow icon
                  color: Colors.grey, // Set the color of the icon
                  size: 20, // Set the size of the icon
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey[400], // Set the color of the divider
          thickness: 1, // Set the thickness of the divider
          height: 20, // Set the height around the divider
        ),
      ],
    );
  }
}
