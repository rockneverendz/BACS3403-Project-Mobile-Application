import 'package:scoped_model/scoped_model.dart';

import 'questiongroup.dart';

class RecordingDTO extends Model {
  int recordingId;
  String title;
  int part;
  String audioURL;
  List<QuestionGroupDTO> questionGroups;

  RecordingDTO(
    this.recordingId,
    this.title,
    this.part,
    this.audioURL,
    this.questionGroups,
  );

  factory RecordingDTO.fromJson(dynamic json) {
    List<dynamic> list = json['questionGroups'];

    List<QuestionGroupDTO> questionGroupDTO = list
        .map<QuestionGroupDTO>((element) => QuestionGroupDTO.fromJson(element))
        .toList();

    return RecordingDTO(
      json['recordingId'],
      json['title'],
      json['part'],
      json['audioURL'],
      questionGroupDTO,
    );
  }

  Map<String, dynamic> toJson() => {
        'RecordingId': recordingId,
        'Title': title,
        'Part': part,
        'AudioURL': audioURL,
        'QuestionGroups': questionGroups.map((e) => e.toJson()).toList(),
      };
}
