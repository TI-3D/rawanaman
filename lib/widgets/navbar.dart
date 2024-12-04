import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rawanaman/pages/camera_page.dart';
import 'package:rawanaman/widgets/transition_bottomslide.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double floatingButtonSize = 65; // Ukuran FloatingActionButton

    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Tata letak tetap
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 28,
                width: 28,
                child: FaIcon(FontAwesomeIcons.home),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 28,
                width: 28,
                child: FaIcon(FontAwesomeIcons.seedling),
              ),
              label: 'My Plant',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 28,
                width: 28,
                child: FaIcon(FontAwesomeIcons.book),
              ),
              label: 'Wiki Plants',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 28,
                width: 28,
                child: FaIcon(FontAwesomeIcons.cog),
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Color(0xff10B982),
          unselectedItemColor: Colors.grey,
          onTap: onItemTapped,
          showUnselectedLabels: true,
          selectedFontSize: 14, // Ukuran font label yang terpilih
          unselectedFontSize: 12, // Ukuran font label yang tidak terpilih
          iconSize: 28, // Ukuran ikon tetap
        ),
        Positioned(
          top: -floatingButtonSize / 1.5, // Posisi mengambang
          left: (MediaQuery.of(context).size.width / 2) -
              (floatingButtonSize / 2),
          child: SizedBox(
            height: floatingButtonSize,
            width: floatingButtonSize,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF10B998), // Warna tombol hijau
                shape: BoxShape.circle, // Membuat bentuk lingkaran
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B998), // Warna bayangan hijau
                    blurRadius: 8, // Jarak bayangan
                    spreadRadius: 1, // Penyebaran bayangan
                    offset: const Offset(0, 1), // Posisi bayangan
                  ),
                ],
              ),
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.camera,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    SlideScaleTransition(page: CameraPage()),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
