import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<String> makePrediction(String imagePath) async {
  // Read the image file
  File imageFile = File(imagePath);
  List<int> imageBytes = await imageFile.readAsBytes();
  String base64Image = base64Encode(imageBytes);

  // Prepare the input data
  Map<String, dynamic> inputData = {
    'image': base64Image,
  };

  final response = await http.post(
    Uri.parse('https://mkemaln.my.id/predict'),
    // Uri.parse(
    //     'https://rawanaman.wibudev.moe/predict'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(inputData),
  );

  if (response.statusCode == 200) {
    // var prediction = json.decode(response.body);
    return response.body;
  } else {
    switch (response.statusCode) {
      case 400:
        throw Exception(
            'Bad Request: The server could not understand the request due to invalid syntax.');
      case 401:
        throw Exception(
            'Unauthorized: Access is denied due to invalid credentials.');
      case 403:
        throw Exception(
            'Forbidden: The server understood the request, but it refuses to authorize it.');
      case 404:
        throw Exception(
            'Not Found: The requested resource could not be found.');
      case 500:
        throw Exception(
            'Internal Server Error: The server encountered a situation it doesn\'t know how to handle.');
      default:
        throw Exception(
            'Failed to make prediction: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
