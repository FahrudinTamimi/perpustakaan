import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() => runApp(MyLibraryApp());

class MyLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
