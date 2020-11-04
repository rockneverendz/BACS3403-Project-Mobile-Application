// A widget that displays the picture taken by the user.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../model/candidate.dart';
import 'face_verified.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Is this a clear image of you?"),
              ),
              SizedBox(width: 250, child: Image.file(File(imagePath))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Retake"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SubmitButton(file: File(imagePath)),
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

class SubmitButton extends StatefulWidget {
  final File file;

  const SubmitButton({Key key, this.file}) : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState(file);
}

class _SubmitButtonState extends State<SubmitButton> {
  final File file;
  bool isLoading = false;

  _SubmitButtonState(this.file);

  @override
  Widget build(BuildContext context) {
    // Get candidate information from main
    Candidate candidate = Candidate.of(context);

    return (isLoading)
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () => handleSubmit(candidate.token, file),
            child: Text("Continue"),
          );
  }

  handleSubmit(String token, File file) {
    setLoading(true);

    submitPhoto(token, file).then((candidate) {
      setLoading(false);
      Navigator.push(
        this.context,
        MaterialPageRoute(builder: (context) => FaceVerified()),
      );
    }, onError: (error) {
      setLoading(false);
      Scaffold.of(this.context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }

  void setLoading(bool bool) {
    setState(() {
      isLoading = bool;
    });
  }

  Future<void> submitPhoto(String token, File imageFile) async {
    // Prepare image to upload
    final stream = new http.ByteStream(imageFile.openRead());
    final length = await imageFile.length();

    // Prepare post uri
    final authority = DotEnv().env['API_URL'];
    final path = '/api/Candidates/VerifyCandidate';
    final param = {'token': token};
    final uri = Uri.https(authority, path, param);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('face', stream, length,
        filename: "face" + extension(imageFile.path));

    // Add token and image to request
    request
      ..fields['token'] = token
      ..files.add(multipartFile);

    try {
      var streamedResponse =
          await request.send().timeout(Duration(seconds: 10));

      // Success
      if (streamedResponse.statusCode == HttpStatus.ok) {
        return;
      }
      // Not Found
      else if (streamedResponse.statusCode == HttpStatus.notFound) {
        return Future.error('Not found!');
      }
      // Not Found
      else if (streamedResponse.statusCode == HttpStatus.badRequest) {
        http.Response response =
            await http.Response.fromStream(streamedResponse);
        Map<String, dynamic> json = jsonDecode(response.body);
        return Future.error(json['Message']);
      }
      // Other
      else {
        return Future.error(
          'Error ${streamedResponse.statusCode.toString()} ${streamedResponse.reasonPhrase}',
        );
      }
    } on SocketException {
      return Future.error('SocketException : Failed to establish connection');
    } on TimeoutException {
      return Future.error('TimeoutException : Failed to establish connection');
    } on Exception catch (Exception) {
      print(Exception);
      return Future.error(Exception.runtimeType.toString());
    }
  }
}
