import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/widgets/card_camerabutton.dart';
import 'package:rawanaman/widgets/navbar.dart';

class FindPlantPage extends StatelessWidget {
  static const routeName = '/findplants';

//   @override
//   _FindPlantsPage createState() => _FindPlantsPage();

//   class _MyPlantsPage {
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(24, 72, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 84),
              Text(
                'Find Plants',
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/settingPage');
                      },
                      child: SvgPicture.asset('assets/svgs/setting.svg'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 84),
              CameraButton()
            ],
          ),
        ),
      ),
    );
  }
}
