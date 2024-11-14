import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/detail_wiki_pages.dart';
import 'package:rawanaman/widgets/transition_slide.dart';

class CardWikiData2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8,
          mainAxisSpacing: 15),
      itemCount: 5, // Number of cards
      itemBuilder: (context, index) {
        return CardWiki2(index: index);
      },
    );
  }
}

class CardWiki2 extends StatelessWidget {
  final int index;

  CardWiki2({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // Buat lingkaran pada Card
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(SlideScaleTransition(page: DetailWikiPage()));
        },
        child: Stack(
          alignment: Alignment.center, // Pusatkan konten di tengah
          children: [
            ClipOval(
              child: Image.network(
                'https://th.bing.com/th/id/OIP.mtUMXpfr_9O8TjUCMRVS1QHaJ4?rs=1&pid=ImgDetMain',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'Plants $index',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 16,
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
