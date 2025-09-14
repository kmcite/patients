import 'package:flutter/material.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

class AuthenticationBloc extends Bloc {
  late final AuthenticationRepository authRepo;
  late final PatientsRepository patientsRepo;

  int selectedIndex = 0;
  final nameController = TextEditingController(text: 'Adn');
  final emailController = TextEditingController(text: 'adn@gmail.com');
  final passwordController = TextEditingController(text: '123456');

  @override
  void initState() {
    authRepo = watch<AuthenticationRepository>();
    patientsRepo = watch<PatientsRepository>();
  }

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> login() async {
    await authRepo.login(emailController.text, passwordController.text);
  }

  Future<void> bypassLogin() async {
    await authRepo.login('adn@gmail.com', '1234');
  }

  bool get invalidCredentials {
    return emailController.text.isEmpty || passwordController.text.isEmpty;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class AuthenticationPage extends Feature<AuthenticationBloc> {
  const AuthenticationPage({super.key});

  @override
  AuthenticationBloc createBloc() => AuthenticationBloc();

  @override
  Widget build(BuildContext context, AuthenticationBloc bloc) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tab selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => bloc.setIndex(0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bloc.selectedIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: bloc.selectedIndex == 0
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          child: const Text('DOCTOR'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => bloc.setIndex(1),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bloc.selectedIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            foregroundColor: bloc.selectedIndex == 1
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
              const SizedBox(height: 24),

              // Form fields
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: bloc.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bloc.emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: bloc.passwordController,
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
              const SizedBox(height: 24),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bloc.invalidCredentials ? null : bloc.login,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: bloc.bypassLogin,
                  child: const Text('Bypass Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
