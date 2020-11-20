import 'package:bacs3403_project_app/model/answer.dart';
import 'package:bacs3403_project_app/model/candidate.dart';
import 'package:bacs3403_project_app/model/questiongroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

class QuestionGroupView extends StatelessWidget {
  final String title;
  final QuestionGroupDTO question;
  final String _authority = DotEnv().env['API_URL'];
  final Function() notifyParent;

  QuestionGroupView({this.title, this.question, @required this.notifyParent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.66,
                child: WebView(
                  initialUrl:
                      'http://' + _authority + question.questionGroupURL,
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.34,
                padding: _padding,
                child: AnswerWidget(
                    question: question, notifyParent: notifyParent),
              )
            ],
          );
        },
      ),
    );
  }
}

class AnswerWidget extends StatefulWidget {
  const AnswerWidget({
    Key key,
    @required this.question,
    @required this.notifyParent,
  }) : super(key: key);

  final QuestionGroupDTO question;
  final Function() notifyParent;

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  int length;
  List<Answer> answer;

  @override
  void initState() {
    super.initState();
    length =
        widget.question.questionNoEnd - widget.question.questionNoStart + 1;
    answer = Candidate.of(context).answer;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (context, index) {
        return TextFormField(
          initialValue:
              answer[widget.question.questionNoStart - 1 + index].writtenAnswer,
          onChanged: (string) => handleChange(index, string),
          decoration: InputDecoration(
              labelText: 'Question ' +
                  (widget.question.questionNoStart + index).toString()),
        );
      },
    );
  }

  void handleChange(int index, String string) {
    answer[widget.question.questionNoStart - 1 + index].writtenAnswer = string;

    // Check if question group is answered
    widget.question.isAnswered = isQuestionGroupCompleted(length, answer);

    this.widget.notifyParent();
  }

  bool isQuestionGroupCompleted(int length, List<Answer> answer) {
    for (int i = 0; i < length; i++) {
      if (answer[widget.question.questionNoStart - 1 + i].writtenAnswer == null) {
        return false;
      }
    }
    return true;
  }
}
