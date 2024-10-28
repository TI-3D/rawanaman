import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_myplants.dart';
import 'package:rawanaman/widgets/navbar.dart';
import 'package:rawanaman/widgets/card_detail_myplants.dart';

class MyPlantsPage extends StatelessWidget {
  static const routeName = '/myplants';

//   @override
//   _MyPlantsPage createState() => _MyPlantsPage();

//   class _MyPlantsPage {
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 72, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 84),
              CardMyPlants()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
