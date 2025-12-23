import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project1/CategoryPage.dart';
import 'package:project1/sign_up.dart';
import 'package:project1/admin_panel.dart';
import 'package:project1/user_panel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MaterialApp(home: Login2()));
}

class Login2 extends StatefulWidget {
  const Login2({Key? key}) : super(key: key);

  @override
  State<Login2> createState() => _LoginState();
}

class _LoginState extends State<Login2> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: Container(
          width: 300,
          height: 450,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }

                    // Check minimum length
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }

                    // Check if contains at least one letter
                    bool hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
                    if (!hasLetter) {
                      return 'Username must contain at least one letter';
                    }

                    // Check if only special characters
                    bool onlySpecialChars = RegExp(
                      r'^[^a-zA-Z0-9]+$',
                    ).hasMatch(value);
                    if (onlySpecialChars) {
                      return 'Username cannot contain only special characters';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }

                    // Check minimum length
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }

                    // Check if contains letters
                    bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(value);
                    if (!hasLetters) {
                      return 'Password must contain letters';
                    }

                    // Check if contains digits
                    bool hasDigits = RegExp(r'[0-9]').hasMatch(value);
                    if (!hasDigits) {
                      return 'Password must contain numbers';
                    }

                    // Combined check
                    if (!hasLetters || !hasDigits) {
                      return 'Password must contain both letters and numbers';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(height: 30),

                // Login and Sign Up buttons side by side
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('User: $username');
                            print('Password: $password');

                            // Check for Admin
                            if (username == 'admin' && password == 'admin.34') {
                              print('Admin Login Success: $username');

                              // Show Admin Toast
                              Fluttertoast.showToast(
                                msg:
                                    '👑 Admin Login Successful! Welcome $username',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.purple,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                              // Navigate to Admin Panel
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AdminPanel(),
                                  ),
                                );
                              });
                            }
                            // Check for Regular User
                            else if (username == 'farshid' &&
                                password == 'farshid.34') {
                              print('Login Success: $username - $password');

                              // Show Success Toast
                              Fluttertoast.showToast(
                                msg: 'Login Successful! Welcome $username',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                              // Navigate to User Panel
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserPanel(),
                                  ),
                                );
                              });
                            } else {
                              // Show Error Toast
                              Fluttertoast.showToast(
                                msg: 'Incorrect Username or Password!',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.red,
                                textColor: Colors.yellow,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
