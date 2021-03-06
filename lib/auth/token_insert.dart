import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'test_info.dart';

class InsertToken extends StatelessWidget {
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
              Image.asset(
                'assets/images/MainLogoAsset1.png',
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
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double progress = 0;
  bool isLoading = false;

  void _handleSubmit() {
    // Validate will return true if the form is valid, or false if the form is invalid.
    if (_formKey.currentState.validate()) {
      _toggleLoading(true);
      submitToken(_controller.text).then((candidate) {
        _toggleLoading(false);
        Candidate.of(context).fill(candidate);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TokenVerified()),
        );
      }, onError: (error) {
        _toggleLoading(false);
        print(error);
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }

  void _toggleLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
      if (isLoading) {
        progress = null;
      } else {
        progress = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Access Token'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter access token';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          (isLoading)
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _handleSubmit();
                    });
                  },
                  child: Text('Continue'),
                ),
        ],
      ),
    );
  }
}

Future<Candidate> submitToken(String token) async {
  final authority = DotEnv().env['API_URL'];
  final path = '/api/Candidates/RedeemToken';
  final body = jsonEncode({'token': token});
  final headers = {"Content-Type": "application/json"};
  final uri = Uri.http(authority, path);

  try {
    final http.Response response = await http
        .post(uri, headers: headers, body: body)
        .timeout(Duration(seconds: 10));

    // Success
    if (response.statusCode == 200)
      return Candidate.fromJson(jsonDecode(response.body));

    // Not Found
    else if (response.statusCode == 404)
      return Future.error('Invalid Token');

    // Not Found
    else if (response.statusCode == 400)
      return Future.error(response.body);

    // Other
    else
      return Future.error('Error ' +
          response.statusCode.toString() +
          " " +
          response.reasonPhrase);
  } on SocketException {
    return Future.error('Failed to establish connection');
  } on TimeoutException {
    return Future.error('Request timed out. Please try again.');
  } on Exception catch (Exception) {
    return Future.error(Exception.runtimeType.toString());
  }
}
