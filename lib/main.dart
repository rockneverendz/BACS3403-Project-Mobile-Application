import 'dart:io';

import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

import 'auth/token_insert.dart';

void main() {
  DotEnv().load('assets/env/.env');

  // Overcome CERTIFICATE_VERIFY_FAILED
  // Not recommended, but solves the problem.
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Candidate candidate = new Candidate();

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<Candidate>(
      model: candidate,
      child: new MaterialApp(
        title: 'Mobile IELTS',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        routes: <String, WidgetBuilder>{
          '/': (context) => InsertToken(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
