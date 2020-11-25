import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bacs3403_project_app/model/answer.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/model/recording.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'completed.dart';
import 'questiongroups.dart';

class SubmitView extends StatelessWidget {
  final String _authority = DotEnv().env['API_URL'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Confirmation"),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnswerListWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SubmitButton(),
          ),
        ],
      ),
    );
  }
}

class AnswerListWidget extends StatefulWidget {
  const AnswerListWidget({
    Key key,
  }) : super(key: key);

  @override
  _AnswerListWidgetState createState() => _AnswerListWidgetState();
}

class _AnswerListWidgetState extends State<AnswerListWidget> {
  Candidate candidate;
  List<Answer> answer;
  List<RecordingDTO> recordings;

  @override
  void initState() {
    super.initState();
    candidate = Candidate.of(context);
    answer = candidate.answer;
    recordings = candidate.recording;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: answer.length,
      itemBuilder: (BuildContext cxt, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Card(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionGroupView(
                    question: recordings
                        .singleWhere((element) =>
                            element.recordingId == answer[index].recordingId)
                        .questionGroups
                        .singleWhere((element) =>
                            element.questionGroupId ==
                            answer[index].recordingGroupId),
                    title: "Editing Question " + (index + 1).toString(),
                    notifyParent: refresh,
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Question " + (index + 1).toString()),
                    answer[index].writtenAnswer != null
                        ? Text(answer[index].writtenAnswer)
                        : Text("Not answered",
                            style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  refresh() {
    setState(() {});
  }
}

class SubmitButton extends StatefulWidget {
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () => handleSubmit(),
            child: Text("Submit Answers"),
          );
  }

  handleSubmit() {
    setLoading(true);

    submitAnswer(context).then((candidate) {
      setLoading(false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Completed(),
        ),
            (Route<dynamic> route) => false,
      );

    }, onError: (error) {
      setLoading(false);
      print(error);
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
}

Future<void> submitAnswer(BuildContext context) async {
  final authority = DotEnv().env['API_URL'];
  final path = '/api/Answers/PostAnswer';
  final uri = Uri.http(authority, path);

  final answer = Candidate.of(context).answer;
  final token = Candidate.of(context).token;

  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({'token': token, 'answers': answer});

  try {
    final http.Response response = await http
        .post(uri, headers: headers, body: body)
        .timeout(Duration(seconds: 10));

    // Success
    if (response.statusCode == HttpStatus.accepted) {
      return;
    }
    // Not Found
    else if (response.statusCode == HttpStatus.notFound) {
      return Future.error('Not found!');
    }
    // Not Found
    else if (response.statusCode == HttpStatus.badRequest) {
      return Future.error('Bad Request!');
    }
    // Other
    else {
      return Future.error(
        'Error ${response.statusCode.toString()} ${response.reasonPhrase}',
      );
    }
  } on SocketException {
    return Future.error('SocketException : Failed to establish connection');
  } on TimeoutException {
    return Future.error('TimeoutException : Failed to establish connection');
  } on Exception catch (Exception) {
    return Future.error(Exception.runtimeType.toString());
  }
}
