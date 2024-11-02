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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          child: GestureDetector(
            onTap: () async {
              // Buka halaman kamera untuk mengambil gambar dan kembalikan `File` gambar
              imageFile = await Navigator.push<File?>(
                context,
                MaterialPageRoute(builder: (_) => CameraPage()),
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
    );
  }
}
