import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.seedling),
          label: 'My Plant',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
          label: 'Find Plant',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.book),
          label: 'Wiki Plants',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green,
      onTap: onItemTapped,
    );
  }
}
