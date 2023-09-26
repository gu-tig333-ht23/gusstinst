import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chore_list.dart';
import 'home_page.dart';

void main() async {
  var choreList = ChoreList();
  await choreList.fetchChores();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              MyAppState(), // tracks the selected filter and the page index
        ),
        ChangeNotifierProvider(
          create: (context) => choreList, // tracks the list with chores
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// For the popupButton, filtering chores
enum FilterItem { all, done, undone }

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;
  FilterItem selectedFilter = FilterItem.all; // shows all by default

  // function for setting index when switching pages/views
  void setIndex(var index) {
    selectedIndex = index;
    notifyListeners();
  }

  // function for setting filter when chosen
  void setFilter(FilterItem item) {
    selectedFilter = item;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: ThemeData(
        // This is the theme of the application.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 4, 169, 106)),
        useMaterial3: true,

        // Theme for the App Bar
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'Times New Roman', fontSize: 22, color: Colors.black),
        ),
      ),
      home: MyHomePage(title: 'ToDo - get it done!'),
    );
  }
}
