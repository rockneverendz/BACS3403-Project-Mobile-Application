import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../auth/face_capture.dart';

const paddingVertical = EdgeInsets.symmetric(vertical: 8);
const paddingAll = EdgeInsets.all(4);

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get candidate information from main
    Candidate candidate = Candidate.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: paddingVertical,
                child: Image.asset(
                  'assets/images/MainLogoAsset1.png',
                ),
              ),
              Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "You have submitted your answers.",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
