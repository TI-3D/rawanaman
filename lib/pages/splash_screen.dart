import 'package:flutter/material.dart';
import 'package:rawanaman/pages/start_page.dart';

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
      MaterialPageRoute(builder: (context) => StartPage()),
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
            Image.asset('assets/images/rawanaman_logo.png', width: 150, height: 150,),
            SizedBox(height: 20),
            Text('RAWANAMAN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}