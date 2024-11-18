// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// Future<String> imageIdentification(String imagePath) async {
//   // Load the TFLite model
//   final interpreter =
//       await Interpreter.fromAsset('assets/model/rwn-epc10.tflite');

//   // Load and preprocess the image
//   File imageFile = File(imagePath);
//   img.Image original = img.decodeImage(imageFile.readAsBytesSync())!;
//   img.Image resized = img.copyResize(original,
//       width: 32, height: 32); // Adjust size based on your model

//   // List<double> input =
//   //     resized.data.map((e) => e / 255.0).toList(); // Normalize to [0, 1]
//   // input = input.map((e) => e.toDouble()).toList(); // Convert to double
//   // input = List.generate(1, (index) => input); // Add batch dimension

//   List<List<List<List<double>>>> input = List.generate(
//     1, // Batch size
//     (i) => List.generate(
//       resized.height, // Height
//       (j) => List.generate(
//         resized.width, // Width
//         (k) => [
//           int pixel = resized.getPixel(j, k);
//           double red = ((pixel >> 16) & 0xFF) / 255.0;   // Extract red channel
//           double green = ((pixel >> 8) & 0xFF) / 255.0; // Extract green channel
//           double blue = (pixel & 0xFF) / 255.0;          // Extract blue channel
//           return [red, green, blue];
//         ],
//       ),
//     ),
//   );

//   // Prepare output buffer
//   List<double> output =
//       List.filled(10, 0.0); // Adjust size based on your model's output

//   // Run inference
//   interpreter.run(input, output);

//   // Class names
//   var namePlant = [
//     'Tomato___Bacterial_spot',
//     'Tomato___Early_blight',
//     'Tomato___Late_blight',
//     'Tomato___Leaf_Mold',
//     'Tomato___Septoria_leaf_spot',
//     'Tomato___Spider_mites Two-spotted_spider_mite',
//     'Tomato___Target_Spot',
//     'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
//     'Tomato___Tomato_mosaic_virus',
//     'Tomato___healthy'
//   ];

//   // Find the index of the highest probability
//   int predictedIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));

//   // Return the predicted class name
//   return namePlant[predictedIndex];
// }

// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// Future<String> imageIdentification(String imagePath) async {
//   // Load the TFLite model
//   final interpreter =
//       await Interpreter.fromAsset('assets/model/rwn-epc10.tflite');

//   // Load and preprocess the image
//   File imageFile = File(imagePath);
//   img.Image original = img.decodeImage(imageFile.readAsBytesSync())!;

//   // Ensure the image is in RGB format
//   img.Image resized = img.copyResize(original,
//       width: 32, height: 32); // Adjust size based on your model

//   List<List<List<List<double>>>> input;
//   if (resized.channels == 3) {
//     // RGB
//     input = List.generate(
//         1,
//         (batch) => List.generate(
//             32,
//             (y) => List.generate(32, (x) {
//                   var pixel = resized.getPixel(x, y);
//                   return [
//                     img.getRed(pixel) / 255.0,
//                     img.getGreen(pixel) / 255.0,
//                     img.getBlue(pixel) / 255.0
//                   ];
//                 })));
//   } else {
//     // Grayscale
//     input = List.generate(
//         1,
//         (batch) => List.generate(
//             32,
//             (y) => List.generate(32, (x) {
//                   var pixel = resized.getPixel(x, y);
//                   return [img.getLuminance(pixel) / 255.0];
//                 })));
//   }

//   // Prepare output buffer
//   List<double> output =
//       List.filled(10, 0.0); // Adjust size based on your model's output

//   // Run inference
//   interpreter.run(input, output);

//   // Class names
//   var namePlant = [
//     'Tomato___Bacterial_spot',
//     'Tomato___Early_blight',
//     'Tomato___Late_blight',
//     'Tomato___Leaf_Mold',
//     'Tomato___Septoria_leaf_spot',
//     'Tomato___Spider_mites Two-spotted_spider_mite',
//     'Tomato___Target_Spot',
//     'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
//     'Tomato___Tomato_mosaic_virus',
//     'Tomato___healthy'
//   ];

//   // Find the index of the highest probability
//   int predictedIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));

//   // Return the predicted class name
//   return namePlant[predictedIndex];
// }

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<String> imageIdentification(String imagePath) async {
  try {
    // Load the TFLite model
    final interpreter =
        await Interpreter.fromAsset('assets/model/rwn-epc10.tflite');

    // Load and preprocess the image
    File imageFile = File(imagePath);
    img.Image? original = img.decodeImage(imageFile.readAsBytesSync());

    if (original == null) {
      throw Exception('Unable to decode image');
    }

    // Resize the image to match model input
    img.Image resized = img.copyResize(original, width: 32, height: 32);

    // Prepare input tensor
    var input = List.generate(
      1,
      (batch) => List.generate(
        32,
        (y) => List.generate(
          32,
          (x) {
            var pixel = resized.getPixel(x, y);
            return [
              (img.getRed(pixel) / 255.0 - 0.5) * 2.0, // Normalize to [-1, 1]
              (img.getGreen(pixel) / 255.0 - 0.5) * 2.0, // Normalize to [-1, 1]
              (img.getBlue(pixel) / 255.0 - 0.5) * 2.0 // Normalize to [-1, 1]
            ];
          },
        ),
      ),
    );

    // Prepare output tensor
    var output = List.generate(1, (index) => List.filled(10, 0.0));

    // Run inference
    interpreter.run(input, output);

    // Class names
    var namePlant = [
      'Tomato___Bacterial_spot',
      'Tomato___Early_blight',
      'Tomato___Late_blight',
      'Tomato___Leaf_Mold',
      'Tomato___Septoria_leaf_spot',
      'Tomato___Spider_mites Two-spotted_spider_mite',
      'Tomato___Target_Spot',
      'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
      'Tomato___Tomato_mosaic_virus',
      'Tomato___healthy'
    ];

    // Find the index of the highest probability
    int predictedIndex =
        output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

    // Close the interpreter
    interpreter.close();

    // Return the predicted class name
    return namePlant[predictedIndex];
  } catch (e) {
    print('Error in image identification: $e');
    rethrow;
  }
}