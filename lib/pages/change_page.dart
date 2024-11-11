import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/login_page.dart'; // Import your login page

class ChangePage extends StatefulWidget {
  final String field; // The field to change (e.g., "password", "email", or "username")

  ChangePage({required this.field});

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> {
  // Controllers for text fields
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser ;

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  Color labelColor1 = Colors.grey[500]!;
  Color labelColor2 = Colors.grey[500]!;
  Color labelColor3 = Colors.grey[500]!;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser ();
  }

  Future<void> _fetchCurrentUser () async {
    currentUser  = _auth.currentUser ;
    if (currentUser  != null) {
      _emailController.text = currentUser !.email!;
      // Fetch username from Firestore
      final uid = currentUser !.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _usernameController.text = userDoc['username'] ?? '';
      }
    }
  }

  Future<void> updateData() async {
    try {
      if (widget.field == 'password') {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          _showMessage("New passwords do not match.");
          return;
        }
        await _updatePassword(_newPasswordController.text);
        Navigator.pop(context);
      } else if (widget.field == 'email') {
        if (_emailController.text == currentUser !.email) {
          _showMessage("New email must be different from the current email.");
          return;
        }
        await _updateEmail(_emailController.text);
        _showEmailVerificationDialog();
      } else if (widget.field == 'username') {
        if (_usernameController.text.isEmpty) {
          _showMessage("Username cannot be empty.");
          return;
        }
        if (_usernameController.text == currentUser !.displayName) {
          _showMessage("New username must be different from the current username.");
          return;
        }
        await _updateUsername(_usernameController.text);
        Navigator.pop(context);
      }
    } catch (e) {
      _showMessage("Error updating ${widget.field}: $e");
    }
  }

  // Function to update the password
  Future<void> _updatePassword(String newPassword) async {
    final credential = EmailAuthProvider.credential(
      email: currentUser !.email!,
      password: _currentPasswordController.text,
    );
    await currentUser !.reauthenticateWithCredential(credential);
    await currentUser !.updatePassword(newPassword);
    _showMessage("Password updated successfully. Please re-login.");
  }

  // Function to update the email
  Future<void> _updateEmail(String newEmail) async {
    if (currentUser  != null) {
      await currentUser !.verifyBeforeUpdateEmail(newEmail);
      _showMessage("Verification email sent. Please check your inbox.");
    }
  }

  Future<void> _updateUsername(String newUsername) async {
    final uid = currentUser !.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'username': newUsername});
      print('Username updated successfully');
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  // Show message in a snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Show dialog after sending verification email
  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Verification Email Sent"),
          content: Text("Please check your inbox for a verification link."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _listenForEmailVerification();
              },
            ),
          ],
        );
      },
    );
  }

  // Listen for email verification
  void _listenForEmailVerification() async {
    User? currentUser  = _auth.currentUser ;

    // Polling mechanism to check if the user is verified
    while (currentUser  != null && !currentUser .emailVerified) {
      await Future.delayed(Duration(seconds: 2));
      await currentUser .reload();
      currentUser  = _auth.currentUser ;
    }

    // Redirect to login page after verification
    if (currentUser  != null && currentUser .emailVerified) {
      _showMessage("Email verified. Please re-login.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(isLogin: true,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F6EF),
      appBar: AppBar(
        title: Text(
          'Change ${widget.field.capitalize()}',
          style: GoogleFonts.firaSans(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.only(left: 23),
          icon: Icon(Icons.arrow_back, color: Color(0xff10B982)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.field == 'password') ...[
              Focus(
                onFocusChange: (hasFocus){
                  setState(() {
                    labelColor1 = hasFocus 
                    ? Color(0xff10B982) 
                    : Colors.grey[500]!;
                  });
                },
                child: TextField(
                  controller: _currentPasswordController,
                  obscureText: _obscureText1,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: TextStyle(
                      color: labelColor1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff10B982), width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;

                        });
                      },
                    ),
                  ),
                ),
              ),
              Focus(
                onFocusChange: (hasFocus){
                  setState(() {
                    labelColor2 = hasFocus 
                    ? Color(0xff10B982) 
                    : Colors.grey[500]!;
                  });
                },
                child: TextField(
                  controller: _newPasswordController,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                      color: labelColor2,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff10B982), width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;

                        });
                      },
                    ),
                  ),
                ),
              ),
              Focus(
                onFocusChange: (hasFocus){
                  setState(() {
                    labelColor3 = hasFocus 
                    ? Color(0xff10B982) 
                    : Colors.grey[500]!;
                  });
                },
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureText3,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(
                      color: labelColor3,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff10B982), width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText3 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText3 = !_obscureText3;

                        });
                      },
                    ),
                  ),
                ),
              ),
            ] else if (widget.field == 'email') ...[
              Focus(
                onFocusChange: (hasFocus){
                  setState(() {
                    labelColor1 = hasFocus 
                    ? Color(0xff10B982) 
                    : Colors.grey[500]!;
                  });
                },
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'New Email Address',
                    labelStyle: TextStyle(
                      color: labelColor1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff10B982), width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                    ),
                  ),
                ),
              ),
            ] else if (widget.field == 'username') ...[
              Focus(
                onFocusChange: (hasFocus){
                  setState(() {
                    labelColor1 = hasFocus 
                    ? Color(0xff10B982) 
                    : Colors.grey[500]!;
                  });
                },
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'New Username',
                    labelStyle: TextStyle(
                      color: labelColor1,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff10B982), width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]!, width: 2),
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateData,
              child: Text(
                'Update ${widget.field.capitalize()}',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff10B982),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}