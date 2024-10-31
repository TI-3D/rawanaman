import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/wiki_article.dart';

class DetailWikiPage extends StatefulWidget {
  const DetailWikiPage({super.key});

  static const routeName = '/plant';

  @override
  _DetailWikiPage createState() => _DetailWikiPage();
}

class _DetailWikiPage extends State<DetailWikiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // margin: const EdgeInsets.fromLTRB(20, 70, 20, 20),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn How to care for Tomato step-by-step',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(16, 185, 130, 0.22),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.bookOpen,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Get to know Tomato Plant',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circle,
                                size: 8,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Introduction'),
                            ],
                          ),
                          // Icon(Icons.arrow_right),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              // second
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(16, 185, 130, 0.22),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.bookOpen,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Environments Where Tomato Thrives',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circle,
                                size: 8,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Watering & Hardiness'),
                            ],
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circle,
                                size: 8,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Sunlight Conditions'),
                            ],
                          ),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circle,
                                size: 8,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Soil Requierments'),
                            ],
                          ),
                          // Icon(Icons.arrow_right),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              // third
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(16, 185, 130, 0.22),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.bookOpen,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Common disease on Tomato Plant',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              // button
              Center(
                child: Container(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, WikiArticle.routeName);
                    },
                    child: Text(
                      'Read More',
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromRGBO(16, 185, 130, 1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
