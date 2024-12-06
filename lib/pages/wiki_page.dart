import 'package:flutter/material.dart';
import 'package:rawanaman/widgets/card_wiki.dart';
import 'package:rawanaman/widgets/card_wiki2.dart';
import 'package:rawanaman/widgets/search_input.dart';
import 'package:rawanaman/widgets/slide_button.dart';
import 'package:google_fonts/google_fonts.dart';

class WikiPage extends StatefulWidget {
  static const routeName = '/wiki';

  @override
  _WikiPage createState() => _WikiPage();
}

class _WikiPage extends State<WikiPage> {
  String selectedMenu = '0';

  void _changeMenu(String menu) {
    setState(() {
      selectedMenu = menu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wiki Plant',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3),
                ),
              ),
              Text(
                'Get to know more about plants',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Hero(
                  tag: 'slideButtonHero',
                  child: SlideButton(
                    onPressed0: () => _changeMenu('0'),
                    onPressed1: () => _changeMenu('1'),
                    selectedMenu: selectedMenu,
                  ),
                ),
              ),
              SearchField(),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: selectedMenu == '0'
                    ? Column(
                        key: ValueKey('menu1'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Plants',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(49, 81, 22, 1.0),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Get to know about your plant’s disease and how to take care of them',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(fontSize: 11),
                                      letterSpacing: 0.3),
                                ),
                              ],
                            ),
                          ),
                          CardWikiData(),
                        ],
                      )
                    : Column(
                        key: ValueKey('menu2'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Other Plants',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Color.fromRGBO(49, 81, 22, 1.0),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Get to know about plants, diseases, and how to take care of them',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CardWikiData2(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
