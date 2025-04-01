import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:ui';
//import 'package:hive_ce_flutter/hive_flutter.dart';
//import 'package:hive_ce/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<BookListController>(() => BookListController());
  runApp(
    GetMaterialApp(
      scrollBehavior: CustomScrollBehavior(),
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

class Breakpoints {
  static const mobile = 600;
  static const tablet = 900;
}

class BookListController {
  final storage = Hive.box("storage");
  RxList bookList;
  BookListController() : bookList = [].obs {
      bookList.value = storage.get('bookList') ?? [];
    }
  /*var bookList = [
    {'title': 'Book 1', 'author': 'Author 1', 'status': 'not started'},
    {'title': 'Book 2', 'author': 'Author 2', 'status': 'reading'},
    {'title': 'Book 3', 'author': 'Author 3', 'status': 'completed'},
  ].obs;*/
  void add(String title, String author) {
    print("new book:");
    var newBook = {'title': title, 'author': author, 'status': 'not started'};
    print(newBook);
    bookList.add(newBook);
    print(bookList);
    storage.put('bookList', bookList);
    Get.to(() => HomeScreen());
  }
  void _save() {
    storage.put('bookList', bookList.map((book) => book).toList());
    Get.to(() => HomeScreen());
  }
  void delete(book) {
    bookList.remove(book);
    bookList.refresh();
    _save();
  }
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
  int getNumberOfCompletedBooks() {
    int number = 0;
    for (var i=0; i<controller.bookList.length; i++) {
      if(controller.bookList[i]['status'] == 'completed') {
        number++;
      }
    }
    return number;
  }
  int getNumberOfBooksToRead() {
    int number = 0;
    for (var i=0; i<controller.bookList.length; i++) {
      if(controller.bookList[i]['status'] == 'not started') {
        number++;
      }
    }
    return number;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text("Bookshelves")),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < Breakpoints.mobile) {  // mobile layout
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 300, child: Column(children: [Text("You have read: ${getNumberOfCompletedBooks()}")])),
                  Container(width: 300, child: Column(children: [Text("Books to read: ${getNumberOfBooksToRead()}")])),
                  Container(width: 300, child: Column(children: [Text("You are currently reading")])),
                ]
              ),
            );
          }
          else if (constraints.maxWidth < Breakpoints.tablet) {  // tablet layout
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 300, child: Column(children: [Text("You have read: ${getNumberOfCompletedBooks()}")])),
                  Container(width: 300, child: Column(children: [Text("Books to read: ${getNumberOfBooksToRead()}")])),
                  Container(width: 300, child: Column(children: [Text("You are currently reading")])),
                ]
              ),
            );
          }
          else {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 300, child: Column(children: [Text("You have read: ${getNumberOfCompletedBooks()}")])),
                  Container(width: 300, child: Column(children: [Text("Books to read: ${getNumberOfBooksToRead()}")])),
                  Container(width: 300, child: Column(children: [Text("You are currently reading")])),
                  Obx(() => Column(
                      children: controller.bookList.map((book) => Text(book["title"])).toList(),
                    )
                  ),
                ]
              ),
            );
          }
        }
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
  static final _formKey = GlobalKey<FormBuilderState>();
  final controller = Get.find<BookListController>();
  _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      var title = _formKey.currentState?.value["title"];
      var author = _formKey.currentState?.value["author"];
      controller.add(title, author);
      _formKey.currentState?.reset();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("New books", style: TextStyle(height: 3, fontSize: 30))),
        Text("Add a new book to reading list"),
        FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  hintText: 'title',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
              FormBuilderTextField(
                name: 'author',
                decoration: InputDecoration(
                  hintText: 'author',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Save"),
              ),
            ]
          )
        ),
        const Divider(),
        Text("Book on readinglist"),
        Column(children: controller.bookList.map((book) => 
          book['status'] == 'not started' 
            ? Card(child: ListTile(
                title: Text(book["title"]), 
                subtitle: Text(book["author"]),
                trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          controller.delete(book);
                        },
                      ),
              ))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}

class ReadingScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("You are currently reading", style: TextStyle(height: 3, fontSize: 30))),
        Column(children: controller.bookList.map((book) => 
          book['status'] == 'reading' 
            ? Card(child: ListTile(title: Text(book["title"]), subtitle: Text(book["author"])))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}

class CompletedScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Center(child: Text("Completed books", style: TextStyle(height: 3, fontSize: 30))),
        Column(children: controller.bookList.map((book) => 
          book['status'] == 'completed' 
            ? Card(child: ListTile(title: Text(book["title"]), subtitle: Text(book["author"])))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Back to Home Screen"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}
