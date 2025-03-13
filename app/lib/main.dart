import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() {
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/notstarted", page: () => NotStartedScreen()),
        GetPage(name: "/reading", page: () => ReadingScreen()),
        GetPage(name: "/completed", page: () => CompletedScreen()),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text("Bookshelves")),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 300, child: Column(children: [Text("You have read: X")])),
            Container(width: 300, child: Column(children: [Text("Books to read: Y")])),
            Container(width: 300, child: Column(children: [Text("You are currently reading")])),
          ]
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text("Not Started"),
              onPressed: () => Get.to(() => NotStartedScreen()),
            ),
            ElevatedButton(
              child: Text("Reading"),
              onPressed: () => Get.to(() => ReadingScreen()),
            ),
            OutlinedButton(
              child: Text("Completed"),
              onPressed: () => Get.to(() => CompletedScreen()),
            ),
          ]
        ),
      ),
    );
  }
}

class NotStartedScreen extends StatelessWidget {
  var booklist = [
    Card(
      child: ListTile(
        //leading: Icon(Icons.),
        title: Text("Clean Code"),
        subtitle: Text("Robert C. Martin"),
      ),
    ),
    Card(
      child: ListTile(
        //leading: Icon(Icons.),
        title: Text("The Firm"),
        subtitle: Text("John Grisham"),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("Not Started Screen")),
        Column(children: booklist),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}

class ReadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("Reading Screen")),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}

class CompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("Completed Screen")),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}
