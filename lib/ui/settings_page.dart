import '../main.dart';

mixin class SettingsBloc {
  Modifier<bool> get dark => darkRepository.dark;
}

class SettingsPage extends UI with SettingsBloc {
  // ignore: prefer_typing_uninitialized_variables
  static var name;

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          IconButton.filled(
            onPressed: () => dark(!dark()),
            icon: Icon(
              dark() ? Icons.dark_mode : Icons.light_mode,
            ),
          ).pad(),
          UserUI(),
        ],
      ),
    );
  }
}
