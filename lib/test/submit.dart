import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'questiongroups.dart';

class SubmitView extends StatelessWidget {
  final String _authority = DotEnv().env['API_URL'];

  @override
  Widget build(BuildContext context) {
    var candidate = Candidate.of(context);
    var answer = candidate.answer;
    var recordings = candidate.recording;

    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Confirmation"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: answer.length,
              itemBuilder: (BuildContext cxt, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: Card(
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionGroupView(
                            question: recordings
                                .singleWhere((element) =>
                                    element.recordingId ==
                                    answer[index].recordingId)
                                .questionGroups
                                .singleWhere((element) =>
                                    element.questionGroupId ==
                                    answer[index].recordingGroupId),
                            title: "Editing Question " + (index + 1).toString(),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Question " + (index + 1).toString()),
                            answer[index].answer != null
                                ? Text(answer[index].answer)
                                : Text("Not answered",
                                    style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Submit Answers"),
            ),
          ),
        ],
      ),
    );
  }
}
