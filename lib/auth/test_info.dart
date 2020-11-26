import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'face_capture.dart';

const paddingVertical = EdgeInsets.symmetric(vertical: 8);
const paddingAll = EdgeInsets.all(4);

class TokenVerified extends StatelessWidget {
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
                child: Table(
                  columnWidths: {0: FractionColumnWidth(.25)},
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: paddingAll,
                          child: Text('Name', textAlign: TextAlign.end),
                        ),
                        Padding(
                          padding: paddingAll,
                          child: Text(candidate.name),
                        ),
                      ],
                    ),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Venue', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text(candidate.test.venue),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Date', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text(
                          new DateFormat.yMMMMd().format(candidate.test.date),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Session', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text(
                          new DateFormat.jm().format(candidate.test.time),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              ContinueButton(
                dateTime: candidate.test.dateTime(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContinueButton extends StatefulWidget {
  ContinueButton({Key key, this.dateTime}) : super(key: key);

  final DateTime dateTime;

  @override
  _ContinueButtonState createState() => _ContinueButtonState(dateTime);
}

class _ContinueButtonState extends State<ContinueButton> {
  Duration _countdown;
  bool isDone = false;

  _ContinueButtonState(DateTime dateTime) {
    DateTime _now = new DateTime.now();
    _countdown = dateTime.difference(_now);

    // TODO: Remember to remove before testing / production
    //_countdown = Duration(seconds: -1);

    // Exam already started
    if (_countdown.isNegative) isDone = true;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: paddingVertical,
      child: Countdown(
        duration: _countdown,
        onFinish: () {
          isDone = true;
        },
        builder: (BuildContext ctx, Duration remaining) {
          if (isDone) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerifyFace()),
                );
              },
              child: Text('Continue to Face Recognition'),
            );
          } else {
            return ElevatedButton(
              onPressed: () {},
              child: Text(printDuration(remaining)),
            );
          }
        },
      ),
    );
  }
}

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}