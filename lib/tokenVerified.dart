import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/verifyFace.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
                date: candidate.test.date,
                time: candidate.test.time,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContinueButton extends StatefulWidget {
  ContinueButton({Key key, this.date, this.time}) : super(key: key);

  final DateTime date;
  final DateTime time;

  @override
  _ContinueButtonState createState() => _ContinueButtonState(date, time);
}

class _ContinueButtonState extends State<ContinueButton> {
  Duration _countdown;
  bool isDone = false;

  _ContinueButtonState(_date, _time) {
    DateTime _dateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    DateTime _now = new DateTime.now();
    _countdown = _dateTime.difference(_now);

    // TODO: Remember to remove before testing / production
    _countdown = Duration(seconds: 3);
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
              child: Text('Continue'),
            );
          } else {
            return ElevatedButton(
              onPressed: () {},
              child: Text(remaining.toString()),
            );
          }
        },
      ),
    );
  }
}
