import 'package:scoped_model/scoped_model.dart';

class QuestionGroupDTO extends Model {
  /*
        Task type 1 – Multiple choice
        Task type 2 – Matching
        Task type 3 – Plan, map, diagram labelling
        Task type 4 – Form, note, table, flow-chart, summary completion
        Task type 5 – Sentence completion
        Task type 6 – Short-answer questions
    */
  int questionGroupId;
  int questionNoStart;
  int questionNoEnd;
  int taskType;
  String questionGroupURL;
  bool isAnswered = false;

  QuestionGroupDTO(
    this.questionGroupId,
    this.questionNoStart,
    this.questionNoEnd,
    this.taskType,
    this.questionGroupURL,
  );

  factory QuestionGroupDTO.fromJson(dynamic json) {
    return QuestionGroupDTO(
      json['questionGroupId'],
      json['questionNoStart'],
      json['questionNoEnd'],
      json['taskType'],
      json['questionGroupURL'],
    );
  }

  Map<String, dynamic> toJson() => {
        'questionGroupId': questionGroupId,
        'questionNoStart': questionNoStart,
        'questionNoEnd': questionNoEnd,
        'taskType': taskType,
        'questionGroupURL': questionGroupURL
      };
}
