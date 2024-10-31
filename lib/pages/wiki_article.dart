import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WikiArticle extends StatefulWidget {
  const WikiArticle({super.key});

  static const routeName = '/manual';

  @override
  _WikiArticle createState() => _WikiArticle();
}

class _WikiArticle extends State<WikiArticle> {
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
                'Get to Know Tomato Plant',
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Introduction',
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '     Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum qui perferendis inventore iste obcaecati debitis dolorum delectus illo repellat cum at praesentium.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Environments Where Tomato Plant Thrives',
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Watering & Hardiness',
                style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '     Lorem ipsum dolor sit amet consectetur adipisicing elit. Ipsum qui perferendis inventore iste obcaecati debitis dolorum delectus illo repellat cum at praesentium.',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                width: double.infinity,
                height: 250,
                color: Color.fromRGBO(217, 217, 217, 1),
                child: Center(
                  child: Text('Ilustrasi Gambar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
