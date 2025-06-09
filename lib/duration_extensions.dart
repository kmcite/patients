extension DurationExtensions on Duration {
  String get formatDuration {
    final years = inDays ~/ 365;
    final months = (inDays % 365) ~/ 30;
    final days = (inDays % 365) % 30;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (years > 0) {
      return '$years years';
    } else if (months > 0) {
      return '$months months';
    } else if (days > 0) {
      return '$days days';
    } else if (hours > 0) {
      return '$hours hours';
    } else if (minutes > 0) {
      return '$minutes minutes';
    } else {
      return '$seconds seconds';
    }
  }

  String get inYears => '${(inDays / 365).ceil()}';
}
