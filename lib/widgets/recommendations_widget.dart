import 'package:flutter/material.dart';

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatment recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250, // Tinggi container diperbesar lagi
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            physics: const BouncingScrollPhysics(), // Animasi scroll
            padding: const EdgeInsets.only(left: 16), // Tambahkan padding awal
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                width: 180, // Lebar kotak diperbesar lagi
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Membuat sudut gambar tumpul dengan ClipRRect
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(0), // Membulatkan sudut gambar
                      child: Image.asset(
                        'assets/images/kuping_gajah.jpg', // Ganti dengan gambar yang sesuai
                        height: 180, // Ukuran gambar
                        width: 160,
                        fit: BoxFit.cover, // Mengisi seluruh area dengan gambar
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Plant of this week',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, // Font lebih besar
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B982)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Color(0xFFEFF7F2),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: RecommendationsWidget(),
      ),
    ),
  ));
}
