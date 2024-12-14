import 'dart:convert'; // Import for JSON encoding
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/config.dart';

const apiKey = Config.apiKey;

Future<void> generateAndSaveText(String plantName) async {
  // check if there were same data exist
  if (await _documentExists(plantName)) {
    print('Document with this name already exists, skipping generation.');
    return; // Exit if the document already exists
  }

  // Generate text
  String generatedText = await _generateText(plantName);

  // Clean the generated text to remove unwanted characters
  String cleanedText = _cleanGeneratedText(generatedText);

  // Parse the generated text into a JSON object
  Map<String, dynamic> jsonData = _parseJson(cleanedText);

  // Save to Firestore
  await _saveToFirestore(jsonData);
}

Future<bool> _documentExists(String name) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('plants');

  // Check if the document with the given name exists
  final querySnapshot = await collectionRef.doc(name).get();
  return querySnapshot.exists; // Returns true if the document exists
}

Future<String> _generateText(String promptPlantName) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  // String prompt =
  //     'tuliskan dengan format nama : $promptPlantName, deskripsi: (singkat), perawatan: (maks 4) [ { jenis_perawatan : sinar matahari nilai : (isi banyak, secukupnya, atau rendah) (sebagai indikator cahaya yang diperlukan) icon:Icons.sunny deskripsi: ... }, { jenis_perawatan : air nilai : (sering, secukupnya, jarang) (sebagai indikator banyak penyiraman yang diperlukan) icon: Icons.water_drop deskripsi: ... }, { jenis_perawatan : pemupukan nilai : (perlu, tidak perlu) (sebagai indikator apakah perlu pemupukan atau tidak) icon: Icons.health_and_safety deskripsi: ... }, { jenis_perawatan : pemangkasan nilai : (perlu, tidak perlu) (sebagai indikator apakah perlu pemangkasan atau tidak) icon: Icons.cut deskripsi: ... }, ]  berbentuk json, disclaimer hanya berikan format json saja';

  String prompt =
      'tuliskan dengan format nama : $promptPlantName, deskripsi: (singkat), genus: , family: , order: , class: , phylum: , nama_latin: , perawatan: (maks 4) [ { jenis_perawatan : sinar matahari nilai : (isi banyak, secukupnya, atau rendah) (sebagai indikator cahaya yang diperlukan) icon:Icons.sunny deskripsi: ... }, { jenis_perawatan : air nilai : (beri nilai integer maks 7 yang menandakan 7hari) (sebagai indikator berapa hari sekali penyiraman yang diperlukan) icon: Icons.water_drop deskripsi: ... }, { jenis_perawatan : pemupukan nilai : (perlu, tidak perlu) (sebagai indikator apakah perlu pemupukan atau tidak) icon: Icons.health_and_safety deskripsi: ... }, { jenis_perawatan : pemangkasan nilai : (perlu, tidak perlu) (sebagai indikator apakah perlu pemangkasan atau tidak) icon: Icons.c/ut deskripsi: ... }, {penyakit_umum: (maks 4)[nama_penyakit: , ciri_penyakit:  ]} ]  berbentuk json, disclaimer hanya berikan format json saja';

  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  return response.text ?? 'No Text generated';
}

String _cleanGeneratedText(String generatedText) {
  // Remove surrounding backticks and trim whitespace
  return generatedText.replaceAll('```json', '').replaceAll('```', '').trim();
}

Map<String, dynamic> _parseJson(String generatedText) {
  // Assuming the generated text is a valid JSON string
  return json.decode(generatedText);
}

Future<void> _saveToFirestore(Map<String, dynamic> jsonData) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('plants');

  // Check if the document with the given name already exists
  String name =
      jsonData['nama'].toLowerCase(); // Extract name from the JSON data
  final querySnapshot =
      await collectionRef.where('tomat', isEqualTo: name.toLowerCase()).get();

  if (querySnapshot.docs.isEmpty) {
    // Document does not exist, save the new document
    await collectionRef.doc(name).set(jsonData);
    await collectionRef.doc(name).update({'created_at': Timestamp.now()});
    print('Document added successfully');
  } else {
    print('Document with this name already exists');
  }
}
