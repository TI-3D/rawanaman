import 'package:flutter/material.dart';
import 'package:rawanaman/pages/camera_page.dart';
import 'package:rawanaman/widgets/transition_bottomslide.dart';

class CardScanNotLeaf extends StatelessWidget {
  const CardScanNotLeaf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: const Text(
                    "The object you scanned is not a leaf.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
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
                      "Re-Scan the object",
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

}
