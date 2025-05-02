import 'package:patients/domain/api/settings_repository.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/custom_app_bar.dart';

class UserPage extends EUI {
  const UserPage({super.key});
  static const name = 'user_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'user profile',
        action: SizedBox(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(settingsRepository.userName),
          ),
          Text(
            'please enter your name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              initialValue: settingsRepository.userName,
              onChanged: (userName) => Events(UserNameChangedEvent(userName)),
            ),
          ),
        ],
      ),
    );
  }
}
