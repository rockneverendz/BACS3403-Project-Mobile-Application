import 'dart:io';

import 'package:bacs3403_project_app/insertToken.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  DotEnv().load('assets/env/.env');

  // Overcome CERTIFICATE_VERIFY_FAILED
  // Not recommended, but solves the problem.
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<Candidate>(
        model: new Candidate(),
        child: new MaterialApp(
          title: 'Mobile IELTS',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          routes: <String, WidgetBuilder>{
            '/': (context) => InsertToken(),
            //'/about': (context) => TokenVerified()
          },
        )
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}