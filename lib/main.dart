import 'package:flutter/material.dart';
import 'package:rawanaman/pages/login_page.dart';
import 'package:rawanaman/pages/register_page.dart';
import 'package:rawanaman/pages/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'rawanaman',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
    ),
    builder: (context, child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(16, 185, 130, 0.3),
              Color.fromRGBO(255, 255, 255, 1.0),
              Color.fromRGBO(255, 255, 255, 1.0),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: child!,
      );
    },
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
      // '/item': (context) => ItemPage(),
    },
  ));
}
