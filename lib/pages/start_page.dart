import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/login_page.dart';
import 'package:rawanaman/widgets/transision_fade.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // "Control Your Garden" text
            Text(
              'Control \nYour Garden',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Row of images around the logo
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center items closely
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/icons/green/lamp.png',
                        width: 50, height: 50),
                    SizedBox(height: 60),
                    Image.asset('assets/images/icons/green/picture.png',
                        width: 60, height: 60),
                    SizedBox(height: 60),
                    Image.asset('assets/images/icons/green/book.png',
                        width: 50, height: 50),
                  ],
                ),
                SizedBox(width: 30), // Reduced spacing here
                Container(
                  height: 282, // Height of the box
                  width: 160, // Width of the box
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo in the center
                      Image.asset(
                        'assets/images/rawanaman_logo.png',
                        height: 42,
                        width: 59,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'RAWANAMAN',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30), // Reduced spacing here
                Column(
                  children: [
                    Image.asset('assets/images/icons/green/leaf.png',
                        width: 50, height: 50),
                    SizedBox(height: 60),
                    Image.asset('assets/images/icons/green/water.png',
                        width: 60, height: 60),
                    SizedBox(height: 60),
                    Image.asset('assets/images/icons/green/sun.png',
                        width: 50, height: 50),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),

            // Description text
            Text(
              'Take Plants of your devices\nwith ease. Simplify your control\nexperience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey[600], fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(FadeThroughPageRoute(
                    page: LoginPage(
                  isLogin: true,
                )));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B982),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 17),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Register button
            TextButton(
              onPressed: () {
                Navigator.of(context).push(FadeThroughPageRoute(
                    page: LoginPage(
                  isLogin: false,
                )));
              },
              child: Text(
                'Register',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF10B982),
                        fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(height: 5),

            // Continue as a guest text
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isGuest', true);
                Navigator.pushReplacementNamed(context, '/main');
              },
              child: Text(
                'Continue as a guest',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
