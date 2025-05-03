import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:ui';
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
        GetPage(name: "/addbook", page: () => AddBookScreen()),
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

  void add(String title, String author, String language) {
    var newBook = {'title': title, 'author': author, 'language': language, 'status': 'not started'};
    print("newBook: ${newBook}");
    bookList.add(newBook);
    storage.put('bookList', bookList);
    Get.to(() => NotStartedScreen());
  }

  void _save() {
    storage.put('bookList', bookList.map((book) => book).toList());
    bookList.refresh();
  }

  void start(book) {
    for (var i=0; i<bookList.length; i++) {
      if (bookList[i] == book) {
        bookList[i]["status"] = "reading";
        break;
      }
    }
    bookList.refresh();
    _save();
    Get.to(() => ReadingScreen());
  }

  void complete(book) {
    for (var i=0; i<bookList.length; i++) {
      if (bookList[i] == book) {
        bookList[i]["status"] = "completed";
        break;
      }
    }
    bookList.refresh();
    _save();
    Get.to(() => CompletedScreen());
  }

  void delete(book) {
    bookList.remove(book);
    bookList.refresh();
    _save();
    Get.to(() => HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  int getNumberOfBooksWithStatus(String status) {
    int number = 0;
    for (var i=0; i<controller.bookList.length; i++) {
      if(controller.bookList[i]['status'] == status) {
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
              margin: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text("Statistics", style: TextStyle(height: 3, fontSize: 30))]),
                  Row(children: [Text("Books to read: ", style: TextStyle(height: 1.2, fontSize: 20)),
                    Text("${getNumberOfBooksWithStatus('not started')}", style: TextStyle(height: 1.2, fontSize: 20))
                  ]),
                  Row(children: [Text("Reading now  : ", style: TextStyle(height: 1.2, fontSize: 20)),
                    Text("${getNumberOfBooksWithStatus('reading')}", style: TextStyle(height: 1.2, fontSize: 20))
                  ]),
                  Row(children: [Text("You have read: ", style: TextStyle(height: 1.2, fontSize: 20)),
                    Text("${getNumberOfBooksWithStatus('completed')}", style: TextStyle(height: 1.2, fontSize: 20))
                  ]),
                ]
              ),
            );
          }
          else if (constraints.maxWidth < Breakpoints.tablet) {  // tablet layout
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text("Statistics", style: TextStyle(height: 3, fontSize: 35))]),
                  Row(children: [Text("Books to read: ", style: TextStyle(height: 1.2, fontSize: 23)),
                    Text("${getNumberOfBooksWithStatus('not started')}", style: TextStyle(height: 1.2, fontSize: 23))
                  ]),
                  Row(children: [Text("Reading now  : ", style: TextStyle(height: 1.2, fontSize: 23)),
                    Text("${getNumberOfBooksWithStatus('reading')}", style: TextStyle(height: 1.2, fontSize: 23))
                  ]),
                  Row(children: [Text("You have read: ", style: TextStyle(height: 1.2, fontSize: 23)),
                    Text("${getNumberOfBooksWithStatus('completed')}", style: TextStyle(height: 1.2, fontSize: 23))
                  ]),
                ]
              ),
            );
          }
          else {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text("Statistics", style: TextStyle(height: 3, fontSize: 40))]),
                  Row(children: [Text("Books to read: ", style: TextStyle(height: 1.2, fontSize: 25)),
                    Text("${getNumberOfBooksWithStatus('not started')}", style: TextStyle(height: 1.2, fontSize: 25))
                  ]),
                  Row(children: [Text("Reading now  : ", style: TextStyle(height: 1.2, fontSize: 25)),
                    Text("${getNumberOfBooksWithStatus('reading')}", style: TextStyle(height: 1.2, fontSize: 25))
                  ]),
                  Row(children: [Text("You have read: ", style: TextStyle(height: 1.2, fontSize: 25)),
                    Text("${getNumberOfBooksWithStatus('completed')}", style: TextStyle(height: 1.2, fontSize: 25))
                  ]),
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
              child: Text("Add Book"),
              onPressed: () => Get.to(() => AddBookScreen()),
            ),
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

class AddBookScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final controller = Get.find<BookListController>();

  _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      controller.add(_formKey.currentState?.value["title"],
                      _formKey.currentState?.value["author"],
                      _formKey.currentState?.value["language"]);
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("New books", style: TextStyle(height: 3, fontSize: 30)),
        Text("Add a new book to reading list", style: TextStyle(height: 3, fontSize: 20)),
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
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              ),
              FormBuilderTextField(
                name: 'author',
                decoration: InputDecoration(
                  hintText: 'author',
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.always,
                validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
              ),
              FormBuilderRadioGroup(
                decoration: InputDecoration(labelText: 'Book language'),
                name: 'language',
                validator: FormBuilderValidators.required(),
                options: ['Finnish', 'Swedish', 'English', 'Norwegian', 'German']
                  .map((lang) => FormBuilderFieldOption(value: lang))
                  .toList(growable: false),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Save"),
              ),
            ]
          )
        ),
        const Divider(),
        Text("Books on reading list", style: TextStyle(height: 3, fontSize: 20)),
        Column(children: controller.bookList.map((book) => 
          book['status'] == 'not started' 
            ? Card(child: ListTile(
                leading: ElevatedButton(
                  onPressed: () => controller.start(book),
                  child: Text("Start"),
                ),
                title: Text(book["title"]), 
                subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.delete(book),
                ),
              ))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Home"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}

class NotStartedScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("Books on reading list", style: TextStyle(height: 3, fontSize: 20)),
        Column(children: controller.bookList.map((book) => 
          book['status'] == 'not started' 
            ? Card(child: ListTile(
                leading: ElevatedButton(
                  onPressed: () => controller.start(book),
                  child: Text("Start"),
                ),
                title: Text(book["title"]), 
                subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.delete(book),
                ),
              ))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Home"),
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
            ? Card(child: ListTile(
                leading: ElevatedButton(
                  onPressed: () => controller.complete(book),
                  child: Text("Complete"),
                ),
                title: Text(book["title"]),
                subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.delete(book),
                ),
              ))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Home"),
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
            ? Card(child: ListTile(
                leading: ElevatedButton(
                  onPressed: () => controller.start(book),
                  child: Text("Reset"),
                ),
                title: Text(book["title"]),
                subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.delete(book),
                ),
              ))
            : Text("")).toList()
        ),
        OutlinedButton(
          child: Text("Home"),
          onPressed: () => Get.to(() => HomeScreen()),
        ),
      ])
    );
  }
}
