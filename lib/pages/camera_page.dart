import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rawanaman/models/gemini.dart';
import 'package:rawanaman/models/rwn-flask.dart';
import 'package:rawanaman/widgets/scan_animation.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late Future<void> cameraInitializer;
  String? imagePath; // Menyimpan jalur gambar yang diambil
  final ImagePicker _imagePicker = ImagePicker();
  final String prompt = 'lidah mertua';

  @override
  void initState() {
    super.initState();
    // Kunci orientasi ke portrait
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });
    cameraInitializer = initializeCamera();
  }

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    // Kembalikan orientasi fleksibel untuk halaman lainnya
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    try {
      XFile picture = await controller.takePicture();
      setState(() {
        imagePath = picture.path;
      });

      // Tampilkan animasi scan
      await showScanAnimation(
        context,
        message: "Scanning your plant...",
        onCompleted: () async {
          // Setelah animasi selesai, lakukan prediksi dan navigasi
          print('start identifying image from camera');
          String healthState = await makePrediction(imagePath!);
          print('finish identify from camera');

          print('start prompt from camera');
          await generateAndSaveText(prompt);
          print('finish prompt from camera');

          if (healthState == 'Healthy') {
            Navigator.pushNamed(context, '/scanResult', arguments: {
              'imagePath': imagePath,
              'nama': prompt,
            });
          } else {
            Navigator.pushNamed(context, '/resultSick', arguments: {
              'imagePath': imagePath,
              'nama': prompt,
              'healthState': healthState,
            });
          }
        },
      );
    } catch (e) {
      print("Error saat mengambil gambar: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Save the path of the selected image
      });
      await processImage(imagePath!);
    }
  }

  Future<void> processImage(String path) async {
    // Tampilkan animasi scan
    await showScanAnimation(context, message: "Scanning your plant...",
        onCompleted: () async {
      print('start identifying image from gallery');
      String healthState = await makePrediction(path);
      print('finish identify from gallery');
      print('healthState = $healthState');

      // Tutup animasi scan setelah selesai

      print('start prompt from gallery');
      await generateAndSaveText(prompt);
      print('finish prompt from gallery');

      // Navigate based on health state
      if (healthState == 'Healthy') {
        Navigator.pushNamed(context, '/scanResult',
            arguments: <String, String?>{
              'imagePath': path,
              'nama': prompt,
            });
      } else {
        Navigator.pushNamed(context, '/resultSick',
            arguments: <String, String?>{
              'imagePath': path,
              'nama': prompt,
              'healthState': healthState,
            });
      }
    });
  }

  Future<void> showScanAnimation(BuildContext context,
      {required String message, required VoidCallback onCompleted}) async {
    await showDialog(
      context: context,
      barrierDismissible:
          false, // Agar pengguna tidak bisa menutup secara manual
      builder: (context) => ScanAnimation(
        message: message,
        onCompleted: onCompleted, // Callback saat animasi selesai
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: cameraInitializer,
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.done)
            ? Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width *
                            controller.value.aspectRatio,
                        child: CameraPreview(controller),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.image,
                                    size: 40,
                                    color: Colors.black), // Gallery icon
                                onPressed: () {
                                  pickImageFromGallery(); // Pick image from gallery
                                },
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (!controller.value.isTakingPicture) {
                                    await takePicture(); // Ambil gambar
                                  }
                                },
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xff10B982),
                                  size: 70,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline,
                                    size: 30, color: Colors.black),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Informasi'),
                                        content: const Text(
                                            'Arahkan kamera ke Tanaman yang ingin di Scan.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Gambar di tengah layar
                  Positioned(
                    top: 90,
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/frame.png', // Ganti dengan path gambar Anda
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Tombol Back di atas
                  Positioned(
                    top: 60,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
