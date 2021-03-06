import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bacs3403_project_app/model/answer.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/model/recording.dart';
import 'package:bacs3403_project_app/test/recordings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
                    child: SampleAudio(),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StartButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartButton extends StatefulWidget {
  @override
  _StartButtonState createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecordingDTO>>(
      future: downloadData(), // function where you call your api
      builder:
          (BuildContext context, AsyncSnapshot<List<RecordingDTO>> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text('Error');
          } else {
            // Initialize Answer array
            var recording = snapshot.data;
            var answer = new List<Answer>(40);
            var index = 0;

            // For each recording
            for (int i = 0; i < recording.length; i++) {
              var questionGroups = recording[i].questionGroups;

              // For each recording group
              for (int j = 0; j < questionGroups.length; j++) {
                var length = questionGroups[j].questionNoEnd -
                    questionGroups[j].questionNoStart +
                    1;

                // For each recording group's question
                for (int k = 0; k < length; k++) {
                  answer[index] = new Answer(index, recording[i].recordingId,
                      questionGroups[j].questionGroupId);
                  index++;
                }
              }
            }

            Candidate.of(context).recording = recording;
            Candidate.of(context).answer = answer;

            return ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TestView(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Start Test'),
            );
          }
        }
      },
    );
  }

  Future<List<RecordingDTO>> downloadData() async {
    Candidate candidate = Candidate.of(context);

    // Prepare post uri
    final authority = DotEnv().env['API_URL'];
    final path = '/api/RecordingLists/CreateRecordingList';
    final body = jsonEncode({'token': candidate.token});
    final headers = {"Content-Type": "application/json"};
    final uri = Uri.http(authority, path);

    try {
      var response = await http
          .post(uri, body: body, headers: headers)
          .timeout(Duration(seconds: 10));

      // Success
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> json = jsonDecode(response.body);
        List<RecordingDTO> object =
            json.map((e) => RecordingDTO.fromJson(e)).toList();
        return Future.value(object);
      }
      // Not Found
      else if (response.statusCode == HttpStatus.notFound) {
        return Future.error('Not found!');
      }
      // Not Found
      else if (response.statusCode == HttpStatus.badRequest) {
        return Future.error('Bad request!');
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
}

class SampleAudio extends StatefulWidget {
  @override
  _SampleAudioState createState() => _SampleAudioState();
}

class _SampleAudioState extends State<SampleAudio> {
  bool isPlaying = false;

  final authority = DotEnv().env['API_URL'];
  final path = '/Storage/AudioRecordings/IELTS-Audio-Test.mp3';
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerCompletion.listen((event) {
      setPlaying(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isPlaying)
        ? ElevatedButton(
            onPressed: () {
              audioPlayer.stop();
              setPlaying(false);
            },
            child: Text('Stop'),
          )
        : ElevatedButton(
            onPressed: () {
              final uri = Uri.http(authority, path);
              audioPlayer.play(uri.toString());
              setPlaying(true);
            },
            child: Text('Sample Audio'),
          );
  }

  void setPlaying(bool bool) {
    setState(() {
      isPlaying = bool;
    });
  }
}
