import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:ui';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

main() {
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
  var bookList = [
    {'title': 'Book 1', 'author': 'Author 1', 'status': 'not started'},
    {'title': 'Book 2', 'author': 'Author 2', 'status': 'reading'},
    {'title': 'Book 3', 'author': 'Author 3', 'status': 'completed'},
  ].obs;
  void add(String title, String author) {
    print("new book:");
    var newBook = {'title': title, 'author': author, 'status': 'not started'};
    print(newBook);
    bookList.add(newBook);
    print(bookList);
  }
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
  List<Obx> getBookList() {
    var bookList = [
                    Obx(() => Text('${controller.bookList[0]['title']} : ${controller.bookList[0]['author']}')),
                    Obx(() => Text('${controller.bookList[1]['title']} : ${controller.bookList[1]['author']}')),
                    Obx(() => Text('${controller.bookList[2]['title']} : ${controller.bookList[2]['author']}')),
                  ];
    return bookList;
  }
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
                  Container(width: 300, child: Column(children: getBookList())),
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
                  Container(width: 300, child: Column(children: getBookList())),
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
                  Container(width: 300, child: Column(children: getBookList())),
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
    print("submitataan");
    if (_formKey.currentState!.saveAndValidate()) {
      var title = _formKey.currentState?.value["title"];
      var author = _formKey.currentState?.value["author"];
      controller.add(title, author);
      _formKey.currentState?.reset();
    }
    Get.back();
  }
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
