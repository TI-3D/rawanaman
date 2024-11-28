import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rawanaman/main.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  final bool isLogin;

  @override
  const LoginPage({Key? key, required this.isLogin}) : super(key: key);

  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late bool _isLogin;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  final _formKey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  var _enteredConfirmedPassword = '';

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  Color labelColor1 = Colors.grey[400]!;
  Color labelColor2 = Colors.grey[400]!;
  Color labelColor3 = Colors.grey[400]!;
  Color labelColor4 = Colors.grey[400]!;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
              'username': _enteredUsername,
            });
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/rawanaman_logo.png",
                      height: 30,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'RAWANAMAN',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin)
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                labelColor4 = hasFocus
                                    ? Color.fromRGBO(16, 185, 130, 1)
                                    : Colors.grey[500]!;
                              });
                            },
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: labelColor4,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(16, 185, 130, 1))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]!)),
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Username must be at least 4 characters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          labelColor1 = hasFocus
                              ? Color.fromRGBO(16, 185, 130, 1)
                              : Colors.grey[500]!;
                        });
                      },
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                            color: labelColor1,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(16, 185, 130, 1))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.grey[500]!)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          labelColor2 = hasFocus
                              ? Color.fromRGBO(16, 185, 130, 1)
                              : Colors.grey[500]!;
                        });
                      },
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: labelColor2,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(16, 185, 130, 1))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.grey[500]!)),
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
                        obscureText: _obscureText1,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _enteredPassword = value;
                        },
                      ),
                    ),
                    if (!_isLogin)
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                labelColor3 = hasFocus
                                    ? Color.fromRGBO(16, 185, 130, 1)
                                    : Colors.grey[500]!;
                              });
                            },
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: labelColor3,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(16, 185, 130, 1))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: Colors.grey[500]!)),
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
                              obscureText: _obscureText2,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value != _enteredPassword) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _enteredConfirmedPassword = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 80),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B982),
                        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                      ),
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin ? 'Create an account' : 'I already have an account',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFF10B982),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
