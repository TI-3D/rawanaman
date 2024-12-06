import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rawanaman/widgets/card_myplants.dart';

class MyPlantsPage extends StatelessWidget {
  static const routeName = '/myplants';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 72, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 65),
              Text(
                'My Plants',
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Keep your plants organized and happy',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 30),
              // FutureBuilder untuk membaca data dari Firestore
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('myplants').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Ambil data dari snapshot
                  final plants = snapshot.data!.docs;

                  if (plants.isEmpty) {
                    return Center(child: Text('No plants found.'));
                  }

                  return CardMyPlants(plants: plants);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
