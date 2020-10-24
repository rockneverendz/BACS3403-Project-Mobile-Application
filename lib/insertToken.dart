import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InsertToken extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/MainLogoAsset1.png',
            ),
            SizedBox(height: 16.0),
            Text(
              'Please enter the token given to verify your identity.',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 16.0),
            AccessTokenInput(),
          ],
        ),
      ),
    );
  }
}

class AccessTokenInput extends StatefulWidget {
  AccessTokenInput({Key key}) : super(key: key);

  @override
  _AccessTokenInputState createState() => _AccessTokenInputState();
}

class _AccessTokenInputState extends State<AccessTokenInput> {
  final _formKey = GlobalKey<FormState>();

  void _handleSubmit() {
    // Validate will return true if the form is valid, or false if the form is invalid.
    if (_formKey.currentState.validate()) {
      // Process data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Access Token',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter access token';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          MaterialButton(
            onPressed: _handleSubmit,
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
