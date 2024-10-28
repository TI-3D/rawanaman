import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWikiData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8),
      itemCount: 5, // Number of cards
      itemBuilder: (context, index) {
        return CardWiki(index: index);
      },
    );
  }
}

class CardWiki extends StatelessWidget {
  final int index;

  CardWiki({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://th.bing.com/th/id/OIP.-A1tyf_ikwJsqIq9UgYD9AHaJQ?rs=1&pid=ImgDetMain',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Plants $index',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
