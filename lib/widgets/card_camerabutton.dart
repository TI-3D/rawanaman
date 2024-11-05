import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:rawanaman/pages/camera_page.dart';
import 'package:image_picker/image_picker.dart';

class CameraButton extends StatefulWidget {
  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  File? imageFile;
  final imagePicker = ImagePicker();
  bool click = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: Container(
              child: GestureDetector(
                onTap: () async {
                  // Menavigasi ke halaman kamera dengan animasi slide
                  imageFile = await Navigator.push<File?>(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CameraPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Mulai dari sisi kanan
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                  setState(() {});
                },
                child: Container(
                  width: 175.0, // Atur ukuran lingkaran
                  height: 175.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B998), // Warna hijau
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
          ),
        ),
      ],
    );
  }
}
