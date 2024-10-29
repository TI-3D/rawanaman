import 'package:flutter/material.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/pages/wiki_page.dart';
import 'package:rawanaman/pages/myplant_page.dart';
import 'package:rawanaman/pages/find_pages.dart';
import 'package:rawanaman/pages/wiki_article.dart';
import 'package:rawanaman/widgets/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rawanaman',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      // initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        DetailWikiPage.routeName: (context) => const DetailWikiPage(),
        WikiArticle.routeName: (context) => const WikiArticle(),
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
    MyPlantPage(),
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
