import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  late Future<void> cameraInitializer;
  String? imagePath; // Menyimpan jalur gambar yang diambil

  @override
  void initState() {
    super.initState();
    cameraInitializer = initializeCamera();
  }

  Future<void> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/Guided_Camera';
    await Directory(directoryPath).create(recursive: true);
    String filePath = '$directoryPath/${DateTime.now()}.jpg';

    try {
      XFile picture = await controller.takePicture();
      setState(() {
        imagePath = picture.path; // Simpan jalur gambar yang diambil
      });
    } catch (e) {
      print("Error saat mengambil gambar: $e");
    }
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.help_outline,
                                      color: Colors.black),
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
                                    size: 60,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.autorenew,
                                      color: Colors.black),
                                  onPressed: () {
                                    // Tambahkan tindakan untuk mengubah kamera di sini
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (imagePath != null) // Menampilkan gambar jika ada
                      Positioned.fill(
                        child: Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/layer_foto.png',
                        fit: BoxFit.cover,
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
                )),
    );
  }
}
