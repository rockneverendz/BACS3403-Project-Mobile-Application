class Test {
  final int testID;
  final String venue;
  final DateTime date;
  final DateTime time;

  Test(
    this.testID,
    this.venue,
    this.date,
    this.time,
  );

  Test.fromJson(Map<String, dynamic> json)
      : testID = json['testID'],
        venue = json['venue'],
        date = DateTime.parse(json['date']),
        time = DateTime.parse(json['time']);

  Map<String, dynamic> toJson() => {
        'testID': testID,
        'venue': venue,
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
      };

  DateTime dateTime() {
    return DateTime(
      this.date.year,
      this.date.month,
      this.date.day,
      this.time.hour,
      this.time.minute,
    );
  }
}
