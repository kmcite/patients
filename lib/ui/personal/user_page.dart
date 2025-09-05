import 'package:forui/forui.dart';
import 'package:patients/domain/api/user_repository.dart';
import 'package:patients/main.dart';

// typedef UserState = ({String userName});

// class UserEvent {}

// class UserNameChangedEvent extends UserEvent {
//   final String userName;
//   UserNameChangedEvent(this.userName);
// }

// class ToggleShowDurationInEvent extends UserEvent {}

// class UpdateJobStartedOnEvent extends UserEvent {
//   BuildContext context;
//   UpdateJobStartedOnEvent(this.context);
// }

// final userBloc = UserBloc();

class UserBloc extends Bloc {
  late UserRepository userRepository = watch();

  late final setName = userRepository.setName;
  late final setJobStartedOn = userRepository.setJobStartedOn;
  late final toggleShowDurationIn = userRepository.toggleShowDurationIn;

  Duration get jobDuration => userRepository.user.jobDuration;
  String get name => userRepository.user.name;
  ShowDurationIn get showDurationIn => userRepository.showDurationIn;
  DateTime get jobStartedOn => userRepository.user.jobStartedOn;

  // UserBloc() {
  //   on<UserNameChangedEvent>(
  //     (event) {
  //       userRepository.updateUser(state..name = event.userName);
  //     },
  //   );
  //   on<ToggleShowDurationInEvent>(
  //     (event) {
  //       final sdi = switch (state.showDurationIn) {
  //         ShowDurationIn.seconds => ShowDurationIn.minutes,
  //         ShowDurationIn.minutes => ShowDurationIn.hours,
  //         ShowDurationIn.hours => ShowDurationIn.days,
  //         ShowDurationIn.days => ShowDurationIn.months,
  //         ShowDurationIn.months => ShowDurationIn.years,
  //         ShowDurationIn.years => ShowDurationIn.seconds,
  //       };
  //       userRepository.updateUser(state..showDurationIn = sdi);
  //     },
  //   );
  //   on<UpdateJobStartedOnEvent>(
  //     (event) async {
  //       final selectedDateTime = await showDatePicker(
  //         context: event.context,
  //         initialDate: state.jobStartedOn,
  //         firstDate: DateTime(1950),
  //         lastDate: DateTime.now(),
  //       );
  //       if (selectedDateTime != null) {
  //         userRepository.updateUser(state..jobStartedOn = selectedDateTime);
  //       }
  //     },
  //   );
  //   _subscription = userRepository().listen((user) => emit(user));
  // }
  // StreamSubscription? _subscription;
  // @override
  // get initialState => userRepository.user();
  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }

  // void setJobStarted(BuildContext context) async {
  //   final selected = await showDatePicker(
  //     context: context,
  //     firstDate: userRepository.user().jobStartedOn,
  //     lastDate: DateTime.now(),
  //   );

  //   if (selected != null) {
  //     // userBloc(UpdateJobStartedOnEvent(context));
  //     userRepository.setJobStartedOn(selected);
  //   }
  // }
}

class UserPage extends UI<UserBloc> {
  const UserPage({super.key});

  @override
  UserBloc create() => UserBloc();

  @override
  Widget build(context, bloc) {
    final duration = bloc.jobDuration;
    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            child: Icon(FIcons.x),
            onPress: () => navigator.back(),
          )
        ],
        title: Text(bloc.name),
      ),
      child: Column(
        children: [
          FTextField(
            label: Text('Name'),
            initialText: bloc.name,
            onChange: bloc.setName,
          ).pad(),
          FButton(
            onPress: () => bloc.toggleShowDurationIn(),
            child: 'Showing in: ${bloc.showDurationIn.name}, Toggle?'.text(),
          ).pad(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('Job Started on ${bloc.jobStartedOn.format}'),
              const SizedBox(height: 8),
              Text(
                switch (bloc.showDurationIn) {
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
                onPress: () async {
                  final selected = await showDatePicker(
                    context: context,
                    firstDate: bloc.jobStartedOn,
                    lastDate: DateTime.now(),
                  );

                  if (selected != null) {
                    bloc.setJobStartedOn(selected);
                  }
                },
                prefix: const Icon(Icons.update),
                child: const Text('Update'),
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
