import 'package:flutter/material.dart';
import 'package:rawanaman/pages/camera_page.dart';
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
                width: double.infinity,
                fit: BoxFit.cover, // Gambar mengisi area tanpa terpotong
              ),
            ),
            // Teks di gambar
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'How to Identify Plants',
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
        title: const Text('Identification Guide'),
        backgroundColor: const Color(0xFF10B982),
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFEAFBF2),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "How to Use the RAWANAMAN App:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  textAlign: TextAlign.justify,
                  "To identify plants and plant diseases, simply take a picture of the plant or select an image from your gallery. RAWANAMAN will instantly analyze it using AI GEMINI!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Tips for Taking Pictures:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTipText(
                    "1. Center the plant in the frame, and avoid dark or blurry images.",
                    "g1.png",
                    width),
                _buildTipText(
                    "2. For large plants, ensure leaves or flowers are included in the frame.",
                    "g2.png",
                    width),
                _buildTipText(
                    "3. Maintain a moderate distance to ensure leaves or flowers are clear and fully visible.",
                    "g3.png",
                    width),
                _buildTipText(
                    "4. Only include one species per scan.", "g4.png", width),
                const SizedBox(height: 15),
                const Text(
                  textAlign: TextAlign.justify,
                  "With your location information, RAWANAMAN can provide more accurate identification results.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Warnings:",
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
                      textAlign: TextAlign.justify,
                      "- Be mindful of your surroundings and ensure safety while capturing images.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.justify,
                      "- Avoid consuming any wild plants.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.justify,
                      "- Refrain from touching unknown wild plants, as some may be toxic or cause allergies.",
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
                      minimumSize: Size(width * 0.8, 50),
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
                        color: Color(0xFF10B982)),
                    label: const Text(
                      "Start Identifying Your Plants!",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF10B982),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipText(String text, String image, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.justify,
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          'assets/images/$image',
          width: width * 0.8,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: InstructionsPage(),
  ));
}
