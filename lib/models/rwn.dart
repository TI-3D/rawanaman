import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

Future<String> imageIdentification(String imagePath) async {
  try {
    // Load the TFLite model with options
    final interpreterOptions = InterpreterOptions()
      ..threads = 4;  // Optional: Use multiple threads for inference

    final interpreter = await Interpreter.fromAsset(
      'assets/model/rwn-epc10.tflite', 
      options: interpreterOptions
    );

    // Print input and output tensor details
    printModelDetails(interpreter);

    // Load and preprocess the image
    File imageFile = File(imagePath);
    img.Image? original = img.decodeImage(imageFile.readAsBytesSync());

    if (original == null) {
      throw Exception('Unable to decode image');
    }

    // Prepare input based on model's expected input shape
    var input = preprocessInput(original, interpreter);

    // Prepare output tensor
    var output = prepareOutputTensor(interpreter);

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
    int predictedIndex = findHighestProbabilityIndex(output);

    // Close the interpreter
    interpreter.close();

    // Return the predicted class name
    return namePlant[predictedIndex];
  } catch (e) {
    print('Error in image identification: $e');
    rethrow;
  }
}

// Detailed model information printing
void printModelDetails(Interpreter interpreter) {
  print('Number of input tensors: ${interpreter.inputTensorCount}');
  print('Number of output tensors: ${interpreter.outputTensorCount}');

  for (int i = 0; i < interpreter.inputTensorCount; i++) {
    var inputTensor = interpreter.getInputTensor(i);
    print('Input Tensor $i:');
    print('  Shape: ${inputTensor.shape}');
    print('  Data Type: ${inputTensor.type}');
    print('  Bytes: ${inputTensor.bytes}');
  }

  for (int i = 0; i < interpreter.outputTensorCount; i++) {
    var outputTensor = interpreter.getOutputTensor(i);
    print('Output Tensor $i:');
    print('  Shape: ${outputTensor.shape}');
    print('  Data Type: ${outputTensor.type}');
    print('  Bytes: ${outputTensor.bytes}');
  }
}

// Flexible input preprocessing
dynamic preprocessInput(img.Image original, Interpreter interpreter) {
  // Get input tensor shape
  var inputTensor = interpreter.getInputTensor(0);
  var inputShape = inputTensor.shape;

  // Resize image to match input shape
  img.Image resized = img.copyResize(
    original, 
    width: inputShape[1], 
    height: inputShape[2]
  );

  // Prepare input based on shape and type
  if (inputShape.length == 4 && inputShape[3] == 3) {
    // RGB input
    return List.generate(
      inputShape[0],  // Batch size
      (batch) => List.generate(
        inputShape[1],  // Height
        (y) => List.generate(
          inputShape[2],  // Width
          (x) => List.generate(
            inputShape[3],  // Channels
            (channel) {
              var pixel = resized.getPixel(x, y);
              double value;
              switch (channel) {
                case 0:
                  value = img.getRed(pixel) / 255.0;
                  break;
                case 1:
                  value = img.getGreen(pixel) / 255.0;
                  break;
                case 2:
                  value = img.getBlue(pixel) / 255.0;
                  break;
                default:
                  value = 0.0;
              }
              // Optional: Normalize to [-1, 1] or as per your model's requirement
              return (value - 0.5) * 2.0;
            }
          )
        )
      )
    );
  } else if (inputShape.length == 4 && inputShape[3] == 1) {
    // Grayscale input
    return List.generate(
      inputShape[0],  // Batch size
      (batch) => List.generate(
        inputShape[1],  // Height
        (y) => List.generate(
          inputShape[2],  // Width
          (x) {
            var pixel = resized.getPixel(x, y);
            double value = img.getLuminance(pixel) / 255.0;
            return (value - 0.5) * 2.0;
          }
        )
      )
    );
  } else {
    throw Exception('Unsupported input shape: $inputShape');
  }
}

// Prepare output tensor dynamically
dynamic prepareOutputTensor(Interpreter interpreter) {
  var outputTensor = interpreter.getOutputTensor(0);
  var outputShape = outputTensor.shape;

  // Create output tensor based on shape
  return List.generate(
    outputShape[0],
    (batch) => List.filled(outputShape[1], 0.0)
  );
}

// Find highest probability index
int findHighestProbabilityIndex(dynamic output) {
  // Handles different output structures
  var probabilities = output is List<List<double>> ? output[0] : output;
  return probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
}