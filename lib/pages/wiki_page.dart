import 'package:flutter/material.dart';
import 'package:rawanaman/widgets/card_wiki.dart';
import 'package:rawanaman/widgets/card_wiki2.dart';
// import 'package:rawanaman/widgets/navbar.dart';
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
  bool _menu1 = true;
  bool _menu2 = false;

  void _changeMenu(String menu) {
    setState(
      () {
        selectedMenu = menu;
        if (selectedMenu == '0') {
          _menu1 = true;
          _menu2 = false;
        } else {
          selectedMenu = '1';
          _menu1 = false;
          _menu2 = true;
        }
      },
    );
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
                  textStyle:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                child: SlideButton(
                  onPressed0: () => _changeMenu('0'),
                  onPressed1: () => _changeMenu('1'),
                  selectedMenu: selectedMenu,
                ),
              ),
              SearchField(),
              Visibility(
                visible: _menu1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Plants',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(49, 81, 22, 1.0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Get to know about your plant’s, disease and how to take care of them',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: CardWikiData()),
                    CardWikiData(),
                  ],
                ),
              ),
              Visibility(
                visible: _menu2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Other Plants',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(49, 81, 22, 1.0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'Get to know about plant’s, disease and how to take care of them',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: CardWikiData()),
                    CardWikiData2(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Navbar(),
    );
  }
}
