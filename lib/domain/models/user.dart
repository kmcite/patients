class User {
  ShowDurationIn showDurationIn = ShowDurationIn.seconds;
  DateTime jobStartedOn = DateTime(2022, 1, 19);
  DateTime firstAllowableDate = DateTime(1950);
  DateTime lastAllowableDate = DateTime(2100);
  String name = "Adn";
  Duration get jobDuration => DateTime.now().difference(jobStartedOn);
  int tracking = 0;
  @override
  String toString() {
    return '$showDurationIn $name $jobDuration';
  }
}

enum ShowDurationIn {
  seconds,
  minutes,
  hours,
  days,
  months,
  years,
}
