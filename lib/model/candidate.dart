import 'package:bacs3403_project_app/model/test.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'recording.dart';

class Candidate extends Model {
  int candidateID;
  String name;
  String token;
  int testID;
  Test test;
  String status;
  List<RecordingDTO> recording;

  Candidate();

  Candidate.fromJson(Map<String, dynamic> json)
      : candidateID = json['candidateID'],
        name = json['name'],
        token = json['token'],
        testID = json['testID'],
        test = Test.fromJson(json['test']),
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'candidateID': candidateID,
        'name': name,
        'token': token,
        'testID': testID,
        'test': test.toJson(),
        'status': status,
      };

  void fill(Candidate candidate) {
    candidateID = candidate.candidateID;
    name = candidate.name;
    token = candidate.token;
    testID = candidate.testID;
    test = candidate.test;
    status = candidate.status;
  }

  /// Wraps [ScopedModel.of] for this [Model].
  static Candidate of(BuildContext context) =>
      ScopedModel.of<Candidate>(context);
}
