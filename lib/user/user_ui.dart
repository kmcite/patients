import '../main.dart';
import 'user_bloc.dart';

class UserUI extends UI {
  const UserUI({super.key});
  @override
  Widget build(BuildContext context) {
    final duration = userBloc.jobDuration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: userBloc.user.name,
          onChanged: userBloc.setName,
          decoration: const InputDecoration(labelText: 'NAME'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField(
          value: userBloc.showDurationIn,
          items: ShowDurationIn.values
              .map(
                (showDurationIn) => DropdownMenuItem(
                  value: showDurationIn,
                  child: Text(showDurationIn.name.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: userBloc.setShowDurationIn,
          decoration: const InputDecoration(labelText: 'SHOW DURATION IN'),
        ),
        const SizedBox(height: 16),
        Text('Job Started on ${userBloc.jobStartedOnString}'),
        const SizedBox(height: 8),
        Text(
          switch (userBloc.showDurationIn) {
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
          onPressed: () => userBloc.setJobStartedOn(context),
          icon: const Icon(Icons.update),
          label: const Text('Update'),
        ),
      ],
    );
  }
}
