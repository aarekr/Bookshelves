import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text("Bookshelves"))),
        body: Center(
          child: Text('Hello World!'),
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Center(
            child: Row(children: [
              OutlinedButton(
                child: Text("To Read"),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text("Reading"),
                onPressed: () {},
              ),
              OutlinedButton(
                child: Text("Completed"),
                onPressed: () {},
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
