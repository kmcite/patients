import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/ui/home.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationView> {
  late final authenticationRepository = watch<AuthenticationRepository>();
  late final patientsRepository = watch<PatientsRepository>();

  int selectedIndex = 0;

  String name = 'Adn';
  String email = 'adn@gmail.com';
  String password = '1234';
  void onNameChanged(String name) {
    this.name = name;
    notifyListeners();
  }

  void onEmailChanged(String email) {
    this.email = email;
    notifyListeners();
  }

  void onPasswordChanged(String password) {
    this.password = password;
    notifyListeners();
  }

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> login() async {
    final result = await authenticationRepository.login(email, password);
    if (result) {
      navigator.to(HomeView());
    }
  }

  Future<void> bypassLogin() async {
    await authenticationRepository.login('adn@gmail.com', '1234');
  }

  bool get invalidCredentials {
    return email.isEmpty || password.isEmpty;
  }
}

class AuthenticationView extends Feature<AuthenticationBloc> {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              // Tab selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.setIndex(0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: controller.selectedIndex == 0
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          child: const Text('DOCTOR'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.setIndex(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.selectedIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: controller.selectedIndex == 1
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          child: const Text('PATIENT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: controller.onNameChanged,
                        initialValue: controller.name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: controller.onEmailChanged,
                        initialValue: controller.email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        onChanged: controller.onPasswordChanged,
                        initialValue: controller.password,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Action buttons
              FilledButton(
                onPressed:
                    controller.invalidCredentials ? null : controller.login,
                child: const Text('Login'),
              ),
              OutlinedButton(
                onPressed: controller.bypassLogin,
                child: const Text('Bypass Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
