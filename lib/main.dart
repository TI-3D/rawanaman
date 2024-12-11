import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rawanaman/pages/camera_page.dart';
import 'package:rawanaman/pages/home_page.dart';
import 'package:rawanaman/pages/login_page.dart';
import 'package:rawanaman/pages/account_page.dart';
import 'package:rawanaman/pages/myplants_page.dart';
import 'package:rawanaman/pages/start_page.dart';
import 'package:rawanaman/widgets/card_care_tips.dart';
import 'package:rawanaman/pages/setting_page2.dart';
import 'package:rawanaman/widgets/card_detail_myplants.dart';
import 'package:rawanaman/widgets/card_full_sun_care.dart';
import 'package:rawanaman/widgets/card_lesson_detail.dart';
import 'package:rawanaman/widgets/card_plant_care_manual.dart';
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
        //'/': (context) => HomePage(),
        '/': (context) => SplashScreen(),
        '/loginPage': (context) => LoginPage(
              isLogin: true,
            ),
        // '/main': (context) => MainScreen(),
        '/main': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int? ?? 1;
          return MainScreen(initialIndex: args);
        },
        '/startPage': (context) => StartPage(),
        '/myplant': (context) => MyPlantsPage(),
        DetailWikiPage.routeName: (context) => const DetailWikiPage(),
        WikiArticle.routeName: (context) => const WikiArticle(),
        '/detail': (context) => DetailMyPlant(),
        '/plantCareManual': (context) => CardPlantCareManual(),
        '/fullSunCare': (context) => CardFullSunCare(),
        '/careTips': (context) => CareTipsDialog(
              jenis: 'jenis',
              deskripsi: 'deskripsi',
              documentId: 'documentId',
            ),
        '/lessonDetail': (context) => CardLessonDetail(),
        '/find-plant': (context) => HomePage(),
        '/cameraPage': (context) => CameraPage(),
        '/scanScreen': (context) => CardScanPict(),
        '/scanResult': (context) => CardResultScan(),
        '/resultSick': (context) => CardScanResultsick(),
        '/diagnoseResult': (context) => CardDiagnosa(),
        '/settingPage': (context) => SettingPage2(),
        '/account': (context) => AccountPage(),
        '/home': (context) => HomePage(),
      },
      // home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;

  MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // int _selectedIndex = 1;
  late int _selectedIndex;

  final List<Widget> _pages = [
    HomePage(),
    MyPlantsPage(),
    Container(),
    WikiPage(),
    SettingPage2(),
  ];

  void initState() {
    super.initState();
    // Initialize _selectedIndex with the value passed from the constructor
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Do nothing if the unclickable tab is tapped
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffa5f4dd),
            Color(0xFFFFFFFF),
          ],
          stops: [0.0, 0.8],
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
