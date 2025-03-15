import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:intl/intl.dart';

main() {
  Get.lazyPut<BookListController>(() => BookListController());
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

class BookListController {
  var bookList = [
    {'title': 'Book 1', 'author': 'Author 1', 'status': 'not started'},
    {'title': 'Book 2', 'author': 'Author 2', 'status': 'reading'},
    {'title': 'Book 3', 'author': 'Author 3', 'status': 'completed'},
  ].obs;
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
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
            Container(width: 300, child: Column(children: [
              Obx(() => Text('${controller.bookList[0]['title']} : ${controller.bookList[0]['author']}')),
              Obx(() => Text('${controller.bookList[1]['title']} : ${controller.bookList[1]['author']}')),
              Obx(() => Text('${controller.bookList[2]['title']} : ${controller.bookList[2]['author']}')),
            ])),
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
        FormWidget(),
        const Divider(),
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

class FormWidget extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  _add() {
    _formKey.currentState?.saveAndValidate();
    print(_formKey.currentState?.value);
  }
  _cancel() {
    _formKey.currentState?.reset();
  }
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text("Add new book to reading list"),
          FormBuilderTextField(
            name: 'title',
            decoration: InputDecoration(
              hintText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          FormBuilderTextField(
            name: 'author',
            decoration: InputDecoration(
              hintText: 'Author',
              border: OutlineInputBorder(),
            ),
          ),
          FormBuilderCheckbox(
            name: 'checkbox',
            title: Text("Checkbox"),
          ),
          FormBuilderSwitch(
            name: 'switch',
            title: Text("Switch"),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: _add,
                child: Text("Add book"),
              ),
              ElevatedButton(
                onPressed: _cancel,
                child: Text("Cancel"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
