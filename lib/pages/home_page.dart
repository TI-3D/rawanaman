import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rawanaman/widgets/card_calender.dart'; // Untuk format tanggal

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now(); // Tanggal fokus pada halaman ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFEAFBF2), // Warna latar belakang hijau muda
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Padding atas
            // Header
            const Text(
              "Hello, Someone!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Stay on top of your plant care routine!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
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
