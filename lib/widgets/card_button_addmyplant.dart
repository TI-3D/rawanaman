import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMyPlantButton extends StatelessWidget {
  final String plantName;
  final String diseaseName;

  AddMyPlantButton({required this.plantName, required this.diseaseName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          _showConfirmationDialog(context);
        },
        child: Text(
          "Add Plant",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Color(0xff10B982), // Warna teks
            ),
          ),
        ),
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            BorderSide(
                color: Color(0xff10B982), width: 1.5), // Outline warna hijau
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
                horizontal: 150, vertical: 12), // Padding di dalam tombol
          ),
          overlayColor: WidgetStateProperty.all(
            Color(0xff10B982)
                .withOpacity(0.1), // Efek klik dengan warna transparan
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context) {
    bool reminder = false; // Nilai awal switch

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Konfirmasi',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Apakah Anda ingin diingatkan untuk penyiraman dan pemupukan?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ingatkan saya",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Switch(
                          activeColor: Color(0xff10B982),
                          inactiveThumbColor: Color(0xff10B982),
                          value: reminder,
                          onChanged: (value) {
                            // Perbarui state lokal menggunakan setState
                            setState(() {
                              reminder = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Tutup dialog
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Panggil fungsi untuk menambahkan tanaman
                            _addPlantToFirebase(reminder);
                            Navigator.of(context).pop(true); // Tutup dialog
                            Navigator.pushNamed(
                                context, '/myplant'); // Navigasi
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: Color(0xff10B982),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add My Plant',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi untuk menyimpan data ke Firebase
  void _addPlantToFirebase(bool reminder) async {
    try {
      final dataPlantsCollection =
          FirebaseFirestore.instance.collection('plants');
      final dataDiseaseCollection =
          FirebaseFirestore.instance.collection('disease');

      DocumentReference plantRef = dataPlantsCollection.doc(plantName);
      DocumentReference diseaseRef = dataDiseaseCollection.doc(diseaseName);

      // Update the post document with the new field that contains the user reference
      await FirebaseFirestore.instance.collection('myplants').add(
          {'plants': plantRef, 'disease': diseaseRef, 'reminder': reminder});

      //   await userPlantsCollection.add({
      //     'plantName': plantName,
      //     'reminder': reminder,
      //     'createdAt': Timestamp.now(),
      //   });
      print("Plant added successfully!");
    } catch (e) {
      print("Failed to add plant: $e");
    }
  }
}
