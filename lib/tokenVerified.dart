import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TokenVerified extends StatelessWidget {
  static const paddingVertical = EdgeInsets.symmetric(vertical: 8);
  static const paddingAll = EdgeInsets.all(4);

  @override
  Widget build(BuildContext context) {
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
                  'images/MainLogoAsset1.png',
                ),
              ),
              Padding(
                padding: paddingVertical,
                child: Text(
                  'Please enter the token given to verify your identity.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Padding(
                padding: paddingVertical,
                child: Table(
                  columnWidths: {0: FractionColumnWidth(.25)},
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Name', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text('TAN AH KAO'),
                      ),
                    ],),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Venue', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text('WP Kuala Lumpur TARUC'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Date', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text('9 August 2020'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: paddingAll,
                        child: Text('Session', textAlign: TextAlign.end),
                      ),
                      Padding(
                        padding: paddingAll,
                        child: Text('10:00 AM'),
                      ),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: paddingVertical,
                child: MaterialButton(
                  //TODO Disable button before exam
                  //onPressed: _handleSubmit,
                  child: Text('Enter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
