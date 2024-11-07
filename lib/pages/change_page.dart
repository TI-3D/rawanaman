import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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


  // Placeholder function for updating data (you can replace this with actual logic)
  Future<void> updateData() async {
    try {
      if (widget.field == 'password') {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          _showMessage("New passwords do not match.");
          return;
        }
        await _updatePassword(_newPasswordController.text);
      } else if (widget.field == 'email') {
        await _updateEmail(_emailController.text);
      } else if (widget.field == 'username') {
        await _updateUsername(_usernameController.text);
      }
      Navigator.pop(context); // Go back to AccountPage after updating
    } catch (e) {
      _showMessage("Error updating ${widget.field}: $e");
    }
  }

  // Function to update the password
  Future<void> _updatePassword(String newPassword) async {
    final currentUser = _auth.currentUser;

    final credential = EmailAuthProvider.credential(
      email: currentUser!.email!,
      password: _currentPasswordController.text,
    );
    await currentUser.reauthenticateWithCredential(credential);
    
    if (currentUser != null) {
      await currentUser.updatePassword(newPassword);
      _showMessage("Password updated successfully. Please re-login.");
    }
  }

  // Function to update the email
  Future<void> _updateEmail(String newEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await currentUser.verifyBeforeUpdateEmail(newEmail);
      _showMessage("Email updated successfully.");
    }
  }

  Future<void> _updateUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;

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
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
              ),
            ] else if (widget.field == 'email') ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'New Email Address'),
              ),
            ] else if (widget.field == 'username') ...[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'New Username'),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateData,
              child: Text('Update ${widget.field.capitalize()}'),
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
