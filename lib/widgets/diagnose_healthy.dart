import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rawanaman/models/gemini2.dart';
import 'package:google_fonts/google_fonts.dart';

class DiagnoseHealthy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menerima data dari arguments, dengan penanganan null safety
    final Map<String, String?>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;

    final String? imagePath = args?['imagePath'];

    ImageProvider imageProvider = imagePath == null
        ? AssetImage('assets/images/kuping_gajah.jpg')
        : FileImage(File(imagePath));

    return Scaffold(
      backgroundColor: Color(0xFFE0F6EF), // Background hijau
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Gambar tanaman di bagian atas
                Container(
                  width: double.infinity,
                  height: 350.0, // Atur tinggi gambar
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Tombol back
                Container(
                  margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                // Card yang menutupi sisa layar di bawah gambar
                Container(
                  margin: EdgeInsets.fromLTRB(0, 295, 0, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          'Looks Healthy! Good Job!', // Nama tanaman
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
