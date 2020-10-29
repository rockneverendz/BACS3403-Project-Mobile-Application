import 'package:bacs3403_project_app/model/test.dart';

class Candidate {
  final int candidateID;
  final String name;
  final String token;
  final int testID;
  final Test test;
  final String status;

  Candidate(
    this.candidateID,
    this.name,
    this.token,
    this.testID,
    this.test,
    this.status,
  );

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
}
