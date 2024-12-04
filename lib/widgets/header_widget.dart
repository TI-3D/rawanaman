import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: const Text(
            'Hello, Someone!',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'FiraSans',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Stay on top of your plant care routine!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Container untuk ikon-ikon
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconWithLabel(
                context: context,
                icon: Icons.nature,
                label: 'My Plants',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/my_plants',
              ),
              _buildIconWithLabel(
                context: context,
                icon: FontAwesomeIcons.camera,
                label: 'Identify',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/identify',
              ),
              _buildIconWithLabel(
                context: context,
                icon: FontAwesomeIcons.book,
                label: 'Book',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/wiki_plant',
              ),
              _buildIconWithLabel(
                context: context,
                icon: Icons.settings,
                label: 'Settings',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/settings',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithLabel({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 36,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Scaffold(
            backgroundColor: Color(0xFFEFF7F2),
            body: Center(child: HeaderWidget()),
          ),
      '/my_plants': (context) => const MyPlantsPage(),
      '/identify': (context) => const IdentifyPage(),
      '/wiki_plant': (context) => const WikiPlantPage(),
      '/settings': (context) => const SettingsPage(),
    },
  ));
}

// Halaman Contoh
class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Plants')),
      body: const Center(child: Text('My Plants Page')),
    );
  }
}

class IdentifyPage extends StatelessWidget {
  const IdentifyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identify Plant')),
      body: const Center(child: Text('Identify Page')),
    );
  }
}

class WikiPlantPage extends StatelessWidget {
  const WikiPlantPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wiki Plant')),
      body: const Center(child: Text('Wiki Plant Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}
