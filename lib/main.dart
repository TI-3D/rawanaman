import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rawanaman/pages/login_page.dart';
import 'package:rawanaman/pages/myplants_page.dart';
import 'package:rawanaman/pages/start_page.dart';
import 'package:rawanaman/widgets/card_camerabutton.dart';
import 'package:rawanaman/widgets/card_detail_myplants.dart';
import 'package:rawanaman/widgets/card_full_sun_care.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';
import 'package:rawanaman/widgets/card_plant_care_manual.dart';
import 'package:rawanaman/pages/findplant_page.dart';
import 'package:rawanaman/pages/setting_page.dart';
import 'package:rawanaman/widgets/card_diagnosa.dart';
import 'package:rawanaman/widgets/card_scan_resultHealth.dart';
import 'package:rawanaman/widgets/card_scan_pict.dart';
import 'package:rawanaman/widgets/card_scan_resultSick.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/pages/wiki_page.dart';
import 'package:rawanaman/pages/wiki_article.dart';
import 'package:rawanaman/widgets/navbar.dart';
import 'package:rawanaman/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //hapus banner
      title: 'rawanaman',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/loginPage': (context) => LoginPage(
              isLogin: true,
            ),
        '/main': (context) => MainScreen(),
        '/startPage': (context) => StartPage(),
        '/myplant': (context) => MyPlantsPage(),
        DetailWikiPage.routeName: (context) => const DetailWikiPage(),
        WikiArticle.routeName: (context) => const WikiArticle(),
        '/detail': (context) => DetailScreen(),
        '/plantCareManual': (context) => CardPlantCareManual(),
        '/fullSunCare': (context) => CardFullSunCare(),
        '/lessonDetail': (context) => CardLessonDetail(),
        '/find-plant': (context) => FindPlantPage(),
        '/cameraPage': (context) => CameraButton(),
        '/scanScreen': (context) => CardScanPict(),
        '/scanResult': (context) => CardResultScan(),
        '/resultSick': (context) => CardScanResultsick(),
        '/diagnoseResult': (context) => CardDiagnosa(),
        '/settingPage': (context) => SettingPage(),
      },
      // home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Start with WikiPage selected

  final List<Widget> _pages = [
    MyPlantsPage(),
    FindPlantPage(),
    WikiPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Navbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
