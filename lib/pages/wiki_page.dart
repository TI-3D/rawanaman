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
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 70, 20, 0),
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
            Expanded(child: CardWikiData2()),
          ],
        ),
      ),
    );
  }
}
