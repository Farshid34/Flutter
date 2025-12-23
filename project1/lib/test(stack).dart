import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyWidget()));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack Example')),
      body: Center(
        child: Stack(
          children: <Widget>[
            // Max Size
            Container(width: 500, height: 400, color: Colors.green),
            Container(width: 400, height: 300, color: Colors.blue),
            Container(width: 300, height: 200, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
