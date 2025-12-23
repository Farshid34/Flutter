import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project1/CategoryPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: Login(),
//   ));
// }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(15),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'نام کاربری',
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
              SizedBox(height: 20),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'رمز عبور',
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  print('User: $username');
                  print('Password: $password');

                  if (username == 'farshid' && password == '1381') {
                    print('Login Success: $username - $password');

                    // showDialog(
                    // context: context,
                    // builder: (context) {
                    // return AlertDialog(
                    // title: const Text(" Welcome message "),
                    // content: const Text(' Welcome user '),
                    // actions: <Widget>[
                    //       ElevatedButton(
                    //             child: const Text('Okey'),
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //           )
                    //         ],
                    //       );
                    //     });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CategoryPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Username or Password is Incorrect'),
                      ),
                    );
                  }
                },

                child: Text('ورود'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
