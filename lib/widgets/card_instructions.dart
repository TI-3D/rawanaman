import 'package:flutter/material.dart';
import 'package:rawanaman/pages/camera_page.dart';
import 'package:rawanaman/widgets/card_camerabutton.dart';
import 'package:rawanaman/widgets/transition_bottomslide.dart';

class CardInstructions extends StatelessWidget {
  const CardInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to InstructionsPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InstructionsPage()),
        );
      },
      child: Card(
        elevation: 4, // Efek bayangan pada card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Sudut melengkung
        ),
        child: Stack(
          children: [
            // Gambar di belakang
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12), // Sudut melengkung untuk gambar
              child: Image.asset(
                'assets/images/foto.jpg',
                height: 250, // Anda dapat menyesuaikan tinggi sesuai kebutuhan
                width: double.infinity,
                fit: BoxFit.cover, // Gambar mengisi area tanpa terpotong
              ),
            ),
            // Teks di gambar
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Cara mengidentifikasi tanaman',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petunjuk untuk Identifikasi'),
        backgroundColor: const Color(0xFF10B982), // AppBar background color
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFEAFBF2), // Green background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Cara menggunakan Aplikasi RAWANAMAN:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Untuk mengidentifikasi tanaman dan penyakit tanaman, cukup ambil gambar tanaman atau pilih gambar tanaman dari 'Foto' Anda dan RAWANAMAN akan mengidentifikasinya secara instan menggunakan AI GEMINI!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tips tentang cara mengambil gambar:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bidikan tanaman yang jelas dengan sudut dan jarak yang tepat akan membantu RAWANAMAN mengidentifikasi tanaman dengan lebih akurat.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "1. Fokuskan tanaman di tengah bingkai, hindari gambar yang gelap atau buram.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/images/g1.png',
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 16),
            const Text(
              "2. Jika tanaman terlalu besar untuk bingkai, pastikan untuk menyertakan daun atau bunga tanaman.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/images/g2.png',
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 16),
            const Text(
              "3. Hindari terlalu dekat, pastikan daun atau bunganya jelas dan lengkap.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/images/g3.png',
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 16),
            const Text(
              "4. Hanya sertakan satu spesies pada satu waktu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Image.asset(
              'assets/images/g4.png',
              height: 400,
              width: 400,
            ),
            const SizedBox(height: 15),
            const Text(
              "Dengan informasi lokasi Anda 'RAWANAMAN' dapat memberi Anda hasil identifikasi yang lebih akurat.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Peringatan:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "- Perhatikan lingkungan sekitar dan tetap aman saat mengambil gambar.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8), // Add space between points
                Text(
                  "- Jangan memakan tanaman liar apa pun.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8), // Add space between points
                Text(
                  "- Jangan menyentuh tanaman liar yang tidak dikenal, karena beberapa mungkin beracun atau dapat menyebabkan alergi.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  iconColor: const Color(0xFFEAFBF2),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    SlideScaleTransition(page: CameraPage()),
                  );
                },
                icon: const Icon(Icons.camera_alt_outlined,
                    color: const Color(0xFF10B982)),
                label: const Text(
                  "Identifikasi Tanaman",
                  style:
                      TextStyle(fontSize: 18, color: const Color(0xFF10B982)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: InstructionsPage(),
  ));
}
