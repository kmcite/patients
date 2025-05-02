import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/main.dart';

typedef UserState = ({String userName});

class UserEvent {}

class UserNameChangedEvent extends UserEvent {
  final String userName;
  UserNameChangedEvent(this.userName);
}

class ToggleShowDurationInEvent extends UserEvent {}

class UpdateJobStartedOnEvent extends UserEvent {
  BuildContext context;
  UpdateJobStartedOnEvent(this.context);
}

final userBloc = UserBloc();

class UserBloc extends Bloc<UserEvent, User> {
  UserBloc() {
    on<UserNameChangedEvent>(
      (event) {
        userRepository.updateUser(state..name = event.userName);
      },
    );
    on<ToggleShowDurationInEvent>(
      (event) {
        final sdi = switch (state.showDurationIn) {
          ShowDurationIn.seconds => ShowDurationIn.minutes,
          ShowDurationIn.minutes => ShowDurationIn.hours,
          ShowDurationIn.hours => ShowDurationIn.days,
          ShowDurationIn.days => ShowDurationIn.months,
          ShowDurationIn.months => ShowDurationIn.years,
          ShowDurationIn.years => ShowDurationIn.seconds,
        };
        userRepository.updateUser(state..showDurationIn = sdi);
      },
    );
    on<UpdateJobStartedOnEvent>(
      (event) async {
        final selectedDateTime = await showDatePicker(
          context: event.context,
          initialDate: state.jobStartedOn,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (selectedDateTime != null) {
          userRepository.updateUser(state..jobStartedOn = selectedDateTime);
        }
      },
    );
    _subscription = userRepository().listen((user) => emit(user));
  }
  StreamSubscription? _subscription;
  @override
  get initialState => userRepository.user();
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class UserPage extends UI {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = userBloc().jobDuration;
    return FScaffold(
      header: FHeader.nested(
        prefixActions: [
          FButton.icon(
            child: FIcon(FAssets.icons.x),
            onPress: () => navigator.back(),
          )
        ],
        title: Text(userBloc().name),
      ),
      content: Column(
        children: [
          FTextField(
            label: Text('Name'),
            initialValue: userBloc().name,
            onChange: (userName) => userBloc(UserNameChangedEvent(userName)),
          ).pad(),
          FButton(
            onPress: () => userBloc(ToggleShowDurationInEvent()),
            label:
                'Showing in: ${userBloc().showDurationIn.name}, Toggle?'.text(),
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('Job Started on ${userBloc().jobStartedOn.format}'),
              const SizedBox(height: 8),
              Text(
                switch (userBloc().showDurationIn) {
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
              FButton(
                onPress: () => userBloc(UpdateJobStartedOnEvent(context)),
                prefix: const Icon(Icons.update),
                label: const Text('Update'),
              ),
            ],
          ).pad(),
        ],
      ),
    );
  }
}

extension on DateTime {
  String get format {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
