import 'package:bacs3403_project_app/auth/test_start.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const paddingVertical = EdgeInsets.symmetric(vertical: 8);

class FaceVerified extends StatelessWidget {
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
              Padding(
                padding: paddingVertical,
                child: Text(
                    'You have successfully pass the face authentication module!',
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: paddingVertical,
                child: Text(
                    'Please scan the seat number (QR Code) on your table to continue',
                    textAlign: TextAlign.center),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TestStart()),
                  );
                },
                child: Text('Scan seat QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
