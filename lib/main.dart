import 'package:flutter/material.dart';
import 'package:rawanaman/pages/findplant_page.dart';

// import 'src/app.dart';
// import 'src/settings/settings_controller.dart';
// import 'src/settings/settings_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, //hapus banner
    title: 'rawanaman',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
    ),
    builder: (context, child) {
      return Container(
        decoration: const BoxDecoration(
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
      FindPlantPage.routeName: (context) => FindPlantPage(),
      '/': (context) => FindPlantPage(),
      // '/item': (context) => ItemPage(),
      // '/detail': (context) => DetailScreen(),
      // '/plantCareManual': (context) => CardPlantCareManual(),
      // '/fullSunCare': (context) => CardFullSunCare(),
      // '/lessonDetail': (context) => CardLessonDetail(),
    },
  ));
}
