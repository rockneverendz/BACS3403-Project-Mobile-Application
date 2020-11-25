import 'package:audioplayers/audioplayers.dart';
import 'package:bacs3403_project_app/auth/test_info.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/model/recording.dart';
import 'package:bacs3403_project_app/test/questiongroups.dart';
import 'package:bacs3403_project_app/test/submit.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'completed.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final authority = DotEnv().env['API_URL'];
  final audioPlayer = AudioPlayer();
  final gapDuration = Future.delayed(Duration(seconds: 1));
  int index = 0;
  Candidate candidate;
  List<RecordingDTO> recordings;

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize Variables
    candidate = Candidate.of(context);
    recordings = candidate.recording;

    // Move on to the next recording once complete
    audioPlayer.onPlayerCompletion.listen((event) async {
      index++;
      if (index < 4) {
        await gapDuration;
        audioPlayer
            .play(Uri.http(authority, recordings[index].audioURL).toString());
      }
    });
    audioPlayer
        .play(Uri.http(authority, recordings[index].audioURL).toString());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Expanded(child: TestDuration(dateTime: candidate.test.dateTime())),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmitView()),
                  );
                },
                child: Icon(
                  Icons.upload_rounded,
                  size: 26.0,
                ),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Part 1'),
              Tab(text: 'Part 2'),
              Tab(text: 'Part 3'),
              Tab(text: 'Part 4'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            TestPart(recording: candidate.recording.elementAt(0)),
            TestPart(recording: candidate.recording.elementAt(1)),
            TestPart(recording: candidate.recording.elementAt(2)),
            TestPart(recording: candidate.recording.elementAt(3)),
          ],
        ),
      ),
    );
  }
}

class TestDuration extends StatefulWidget {
  const TestDuration({Key key, this.dateTime}) : super(key: key);

  final DateTime dateTime;

  @override
  _TestDurationState createState() => _TestDurationState(dateTime);
}

class _TestDurationState extends State<TestDuration> {
  Duration _countdown;
  bool isDone = false;

  _TestDurationState(DateTime dateTime) {
    DateTime _now = new DateTime.now();
    var endTime = dateTime.add(Duration(minutes: 40));
    _countdown = endTime.difference(_now);

    // If exam is already over give some seconds
    if (_countdown.isNegative) _countdown = Duration(seconds: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      duration: _countdown,
      onFinish: () {
        forceSubmit();
      },
      builder: (BuildContext ctx, Duration remaining) {
        return Text("Time Remaining " + printDuration(remaining));
      },
    );
  }

  forceSubmit() {
    submitAnswer(context).then((candidate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Completed(),
        ),
        (Route<dynamic> route) => false,
      );
    }, onError: (error) {
      Scaffold.of(this.context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }
}

class TestPart extends StatefulWidget {
  final RecordingDTO recording;

  const TestPart({Key key, this.recording}) : super(key: key);

  @override
  _TestPartState createState() => _TestPartState(recording);
}

class _TestPartState extends State<TestPart>
    with AutomaticKeepAliveClientMixin<TestPart> {
  final RecordingDTO recording;

  _TestPartState(this.recording);

  // Prevent flutter from unloading the widget
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      itemCount: recording.questionGroups.length,
      itemBuilder: (_, index) {
        var questionGroup = recording.questionGroups[index];
        var questionGroupTitle = "Question " +
            questionGroup.questionNoStart.toString() +
            " ~ " +
            questionGroup.questionNoEnd.toString();

        return Card(
          child: ListTile(
            title: Text(questionGroupTitle),
            trailing: questionGroup.isAnswered
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionGroupView(
                  question: questionGroup,
                  title: "Part " +
                      recording.part.toString() +
                      " " +
                      questionGroupTitle,
                  notifyParent: refresh,
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
