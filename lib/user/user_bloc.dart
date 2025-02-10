import 'package:patients/main.dart';
import 'package:patients/user/user_repository.dart';

final userBloc = UserBloc();

class UserBloc {
  UserRepository get _userRepository => userRepository;

  Duration get jobDuration => user.jobDuration;
  DateTime get jobStartedOn => user.jobStartedOn;
  User get user => _userRepository.user;
  ShowDurationIn get showDurationIn => user.showDurationIn;

  void setUser(User value) => _userRepository.setUser(value);
  void setShowDurationIn(ShowDurationIn? showDurationIn) =>
      setUser(user..showDurationIn = showDurationIn!);
  void setName(String name) => setUser(user..name = name);

  void setJobStartedOn(BuildContext context) async {
    final selectedDateTime = await showDatePicker(
      context: context,
      initialDate: jobStartedOn,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selectedDateTime != null) {
      setUser(user..jobStartedOn = selectedDateTime);
    }
  }

  String get jobStartedOnString =>
      DateFormat('dd/MM/yyyy').format(jobStartedOn);
}
