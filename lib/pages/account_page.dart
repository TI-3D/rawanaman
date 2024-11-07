import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rawanaman/pages/change_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch both username and email
  }

  // Fetch username from Firestore and email from FirebaseAuth
  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Set email from FirebaseAuth
        email = currentUser.email;

        // Fetch username from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (mounted){
          setState(() {
            username = userDoc['username'] ?? 'No Username'; // Get username or default
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
      if (mounted) {
        setState(() {
          username = 'Error loading username';
          email = 'Error loading email';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F6EF),
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
          'Account',
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
                'Account Information',
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
            // Container for displaying Username and Email
            Container(
              padding: EdgeInsets.symmetric(vertical: 11),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Username ListTile
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.black),
                    title: Text(
                      'Username',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Text(
                      username ?? 'Loading...', // Display the username
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to ChangePage for updating username
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePage(field: 'username'),
                        ),
                      );
                    },
                  ),

                  // Email ListTile
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.black),
                    title: Text(
                      'Email',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Text(
                      email ?? 'Loading...', // Display the email
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to ChangePage for updating email
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePage(field: 'email'),
                        ),
                      );
                    },
                  ),

                  // Change Password ListTile
                  ListTile(
                    title: Text(
                      'Change Password',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.navigate_next_rounded, color: Colors.black),
                    onTap: () {
                      // Navigate to ChangePage for updating password
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePage(field: 'password'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 41),
          ],
        ),
      ),
    );
  }
}
