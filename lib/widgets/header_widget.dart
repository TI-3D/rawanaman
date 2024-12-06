import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rawanaman/pages/camera_page.dart';

class HeaderWidget extends StatelessWidget {
  final void Function(String routeName, dynamic arguments)? onNavigate;

  const HeaderWidget({Key? key, this.onNavigate}) : super(key: key);

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
                icon: FontAwesomeIcons.seedling,
                label: 'My Plants',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/main',
                arguments: 1,
              ),
              _buildIconWithLabel(
                icon: FontAwesomeIcons.camera,
                label: 'Identify',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/main',
                arguments: 5,
              ),
              _buildIconWithLabel(
                icon: FontAwesomeIcons.book,
                label: 'Book',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/main',
                arguments: 3,
              ),
              _buildIconWithLabel(
                icon: Icons.settings,
                label: 'Settings',
                iconColor: const Color(0xFF10B982),
                textColor: const Color(0xFF10B982),
                routeName: '/main',
                arguments: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithLabel({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color textColor,
    required String routeName,
    dynamic arguments,
  }) {
    return GestureDetector(
      onTap: () {
        if (onNavigate != null) {
          onNavigate!(routeName, arguments);
        }
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
