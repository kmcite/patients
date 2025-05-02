import 'package:patients/domain/api/user_repository.dart';

import '../main.dart';

mixin class UserBloc {
  Modifier<User> get user => userRepository.user;

  Duration get jobDuration => user().jobDuration;
  DateTime get jobStartedOn => user().jobStartedOn;
  ShowDurationIn get showDurationIn => user().showDurationIn;

  void setShowDurationIn(ShowDurationIn? showDurationIn) =>
      user(user()..showDurationIn = showDurationIn!);
  void setName(String name) => userRepository.user(user()..name = name);

  void setJobStartedOn(BuildContext context) async {
    final selectedDateTime = await showDatePicker(
      context: context,
      initialDate: jobStartedOn,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selectedDateTime != null) {
      user(user()..jobStartedOn = selectedDateTime);
    }
  }

  String get jobStartedOnString =>
      DateFormat('dd/MM/yyyy').format(jobStartedOn);
}

class UserUI extends UI with UserBloc {
  const UserUI({super.key});
  @override
  Widget build(BuildContext context) {
    final duration = jobDuration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: user().name,
          onChanged: setName,
          decoration: const InputDecoration(labelText: 'NAME'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField(
          value: showDurationIn,
          items: ShowDurationIn.values
              .map(
                (showDurationIn) => DropdownMenuItem(
                  value: showDurationIn,
                  child: Text(showDurationIn.name.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: setShowDurationIn,
          decoration: const InputDecoration(labelText: 'SHOW DURATION IN'),
        ),
        const SizedBox(height: 16),
        Text('Job Started on $jobStartedOnString'),
        const SizedBox(height: 8),
        Text(
          switch (showDurationIn) {
            ShowDurationIn.years =>
              '${(duration.inDays / 365).toStringAsFixed(2)} years',
            ShowDurationIn.months =>
              '${(duration.inDays / 30).toStringAsFixed(2)} months',
            ShowDurationIn.days => '${duration.inDays} days',
            ShowDurationIn.hours => '${duration.inHours} hours',
            ShowDurationIn.minutes => '${duration.inMinutes} minutes',
            ShowDurationIn.seconds => '${duration.inSeconds} seconds',
          },
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => setJobStartedOn(context),
          icon: const Icon(Icons.update),
          label: const Text('Update'),
        ),
        user().text(),
      ],
    );
  }
}
