import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    await _cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // tampilan utama
  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.black),
                    onPressed: () {
                      // Tambahkan info ketika ditekan
                    },
                  ),
                  /*ini harusnya ke logika di backend. Sementara aku ganti ke GestureDetector().
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      Navigator.pushNamed(context,
                          '/scanScreen');
                      await _cameraController!.takePicture();
                    },
                    child: Icon(Icons.camera_alt),
                  ),*/
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/scanScreen'); // Route untuk Scan
                    },
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xff10B982),
                      size: 50,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.autorenew, color: Colors.black),
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
    );
  }
}
