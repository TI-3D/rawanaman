import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Make sure to add the Lottie package to your pubspec.yaml

class ScanAnimation extends StatefulWidget {
  final String message;
  final VoidCallback onCompleted; // Callback untuk aksi setelah animasi selesai

  const ScanAnimation({
    Key? key,
    required this.message,
    required this.onCompleted,
  }) : super(key: key);

  @override
  _ScanAnimationState createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<ScanAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted(); // Panggil callback
      }
    });
    _controller.forward(); // Mulai animasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/scan_animation.json',
              width: 240,
              height: 240,
              fit: BoxFit.contain,
              controller: _controller,
            ),
            const SizedBox(height: 20),
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Function to show the scan animation as a modal
// Future<void> showScanAnimation(BuildContext context,
//     {required String message}) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: false, // Prevent closing the dialog by tapping outside
//     builder: (BuildContext context) {
//       return ScanAnimation(message: message, onCompleted: () {  },);
//     },
//   );
// }
