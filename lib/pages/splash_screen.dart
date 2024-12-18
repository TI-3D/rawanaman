import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rawanaman/main.dart';
import 'package:rawanaman/pages/start_page.dart';
import 'package:rawanaman/pages/wiki_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthCheck()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/rawanaman_logo.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text('RAWANAMAN',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  Future<bool> checkGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isGuest') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkGuestStatus(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Scaffold(
          //     body: Center(
          //       child: Image.asset(
          //         'assets/images/rawanaman_logo.png',
          //         width: 150,
          //         height: 150,
          //       ),
          //     ),
          //   );
          // }

          if (snapshot.hasData && snapshot.data == true) {
            // Jika pengguna adalah "guest", arahkan ke MainScreen
            return MainScreen();
          }

          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Scaffold(
                //     body: Center(
                //       child: Image.asset(
                //         'assets/images/rawanaman_logo.png',
                //         width: 150,
                //         height: 150,
                //       ),
                //     ),
                //   );
                // }

                if (snapshot.hasData) {
                  return MainScreen();
                }
                return StartPage();
              });
        });
  }
}
