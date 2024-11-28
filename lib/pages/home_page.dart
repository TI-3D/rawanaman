import 'package:flutter/material.dart';
import 'package:rawanaman/widgets/card_calender.dart'; // Untuk format tanggal

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFEAFBF2), // Warna latar belakang hijau muda
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 40), // Padding atas
            // Header
            Text(
              "Hello, Someone!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Stay on top of your plant care routine!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24),
            // Kalender Realtime
            Expanded(
              child: CustomCalendar(), // Panggil widget kalender Anda
            ),
          ],
        ),
      ),
    );
  }
}
