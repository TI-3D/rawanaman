import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Controllers untuk input username dan password
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Default values untuk username dan password
  String _username = "Username Sebelumnya";
  String _password = "Password Sebelumnya";

  // Fungsi untuk menampilkan dialog input
  void _showEditDialog(
      String title, TextEditingController controller, Function onSave) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Masukkan $title baru"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                onSave();
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F6EF), // Background hijau muda,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: 23),
          icon: Icon(Icons.arrow_back, color: Color(0xff10B982)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.firaSans(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(left: 32),
              child: Text(
                'Account Settings',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Container untuk Username dan Password
            Container(
              padding: EdgeInsets.fromLTRB(36, 11, 42, 11),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  // Username Row
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.black),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              _username,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _usernameController.text = _username;
                          _showEditDialog("Username", _usernameController, () {
                            setState(() {
                              _username = _usernameController.text;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  Divider(
                      color:
                          Colors.grey), // Pemisah antara Username dan Password
                  SizedBox(height: 8),
                  // Password Row
                  Row(
                    children: [
                      Icon(Icons.lock, color: Colors.black),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              _password,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _passwordController.text = _password;
                          _showEditDialog("Password", _passwordController, () {
                            setState(() {
                              _password = _passwordController.text;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 41),
            // Logout Button
            Center(
              child: GestureDetector(
                onTap: () {
                  // Tambahkan logika logout di sini
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/loginPage');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
