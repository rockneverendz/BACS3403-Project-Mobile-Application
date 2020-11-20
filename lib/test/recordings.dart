import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/model/recording.dart';
import 'package:bacs3403_project_app/test/questiongroups.dart';
import 'package:bacs3403_project_app/test/submit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Candidate candidate = Candidate.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('IELTS Listening Test'),
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
      itemBuilder: (_, index) => Card(
        child: ListTile(
          title: Text("Question group " + (index + 1).toString()),
          trailing: recording.questionGroups[index].isAnswered
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionGroupView(
                question: recording.questionGroups[index],
                title: "Part " +
                    recording.part.toString() +
                    " Question Group " +
                    (index + 1).toString(),
                notifyParent: refresh,
              ),
            ),
          ),
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
