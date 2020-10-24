import 'package:bacs3403_project_app/insertToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile IELTS',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
          body: InsertToken()
      ),
    );
  }
}
