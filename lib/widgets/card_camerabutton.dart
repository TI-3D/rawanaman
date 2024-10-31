import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
                context, '/cameraPage'); // Route untuk Camera Page
          },
          child: Container(
            width: 175.0, // Atur ukuran lingkaran
            height: 175.0,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981), // Warna hijau
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, 4), // Atur offset bayangan
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/camera_icon.svg', // Path ke file SVG ikon kamera
                width: 78.0,
                height: 78.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
