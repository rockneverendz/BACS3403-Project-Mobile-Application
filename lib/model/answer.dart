import 'package:scoped_model/scoped_model.dart';

class Answer extends Model {
  int index;
  int recordingId;
  int recordingGroupId; // For tracing back
  String writtenAnswer;

  Answer(this.index, this.recordingId, this.recordingGroupId);

  Map<String, dynamic> toJson() => {
        'index': index,
        'writtenAnswer': writtenAnswer,
        'recordingId': recordingId,
      };
}
