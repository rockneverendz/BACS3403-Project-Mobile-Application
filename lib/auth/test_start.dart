import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

const paddingVertical = EdgeInsets.symmetric(vertical: 8);
const paddingAll = EdgeInsets.all(4);

class TestStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get candidate information from main
    Candidate candidate = Candidate.of(context);
    String instructions = '''
Instructions

Please verify your details before pressing start.

Put on your headphones and test your audio.

Listen to the instructions for each part/section of the paper carefully.

Answer all the questions.''';

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
                padding: paddingAll,
                child: Text(
                  instructions,
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
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
                          DateFormat.yMMMMd().format(candidate.test.date),
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
                          DateFormat.jm().format(candidate.test.time),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Sample Audio'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => null),
                        // );
                      },
                      child: Text('Start Test'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
