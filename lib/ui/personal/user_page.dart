import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/domain/models/user.dart';
import 'package:patients/utils/architecture.dart';

class UserBloc extends Bloc {
  late final UserRepository userRepository;

  @override
  void initState() {
    userRepository = watch<UserRepository>();
  }

  Duration get jobDuration => userRepository.user.jobDuration;
  String get name => userRepository.user.name;
  ShowDurationIn get showDurationIn => userRepository.showDurationIn;
  DateTime get jobStartedOn => userRepository.user.jobStartedOn;

  void setName(String name) => userRepository.setName(name);
  void setJobStartedOn(DateTime date) => userRepository.setJobStartedOn(date);
  void toggleShowDurationIn() => userRepository.toggleShowDurationIn();
}

class UserPage extends BlocWidget<UserBloc> {
  const UserPage({super.key});

  @override
  UserBloc createBloc() => UserBloc();

  @override
  Widget build(BuildContext context, UserBloc bloc) {
    final duration = bloc.jobDuration;
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            child: const Icon(FIcons.x),
            onPress: () => Navigator.of(context).pop(),
          )
        ],
        title: Text(bloc.name),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FTextField(
              label: const Text('Name'),
              initialText: bloc.name,
              onChange: bloc.setName,
            ),
            const SizedBox(height: 16),
            FButton(
              onPress: bloc.toggleShowDurationIn,
              child: Text('Showing in: ${bloc.showDurationIn.name}, Toggle?'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Text('Job Started on ${bloc.jobStartedOn.format}'),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(duration, bloc.showDurationIn),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  FButton(
                    onPress: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: bloc.jobStartedOn,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );

                      if (selected != null) {
                        bloc.setJobStartedOn(selected);
                      }
                    },
                    prefix: const Icon(Icons.update),
                    child: const Text('Update Job Start Date'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration, ShowDurationIn showIn) {
    switch (showIn) {
      case ShowDurationIn.years:
        return '${(duration.inDays / 365).toStringAsFixed(2)} years';
      case ShowDurationIn.months:
        return '${(duration.inDays / 30).toStringAsFixed(2)} months';
      case ShowDurationIn.days:
        return '${duration.inDays} days';
      case ShowDurationIn.hours:
        return '${duration.inHours} hours';
      case ShowDurationIn.minutes:
        return '${duration.inMinutes} minutes';
      case ShowDurationIn.seconds:
        return '${duration.inSeconds} seconds';
    }
  }
}

extension on DateTime {
  String get format {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
