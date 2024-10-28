import 'package:flutter/material.dart';
import 'package:rawanaman/pages/wiki_page.dart';

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
      WikiPage.routeName: (context) => WikiPage(),
      '/': (context) => WikiPage(),
      // '/item': (context) => ItemPage(),
    },
  ));
}
