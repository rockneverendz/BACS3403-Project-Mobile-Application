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

  QuestionGroupView({this.title, this.question});

  @override
  Widget build(BuildContext context) {
    final int length = question.questionNoEnd - question.questionNoStart;

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
                child: ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Question ' +
                              (question.questionNoStart + index).toString()),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
