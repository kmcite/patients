import 'package:flutter/material.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/ui/home/home_page.dart';

/// Login Bloc - handles login logic and form state
class LoginBloc extends Bloc {
  late final AuthenticationRepository authRepo;

  final emailController = TextEditingController(text: 'adn@gmail.com');
  final passwordController = TextEditingController(text: '1234');
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    authRepo = watch<AuthenticationRepository>();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    await authRepo.login(
      emailController.text.trim(),
      passwordController.text,
    );

    // Navigate to home if login successful
    if (authRepo.isAuthenticated) {
      navigator.to(HomePage());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

/// Login Page Widget
class LoginPage extends Feature<LoginBloc> {
  const LoginPage({super.key});

  @override
  LoginBloc createBloc() => LoginBloc();

  @override
  Widget build(BuildContext context, LoginBloc bloc) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: bloc.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo/Header
                      Icon(
                        Icons.local_hospital,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Patients Management',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Sign in to continue',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      TextFormField(
                        controller: bloc.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Email required';
                          if (!value!.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: bloc.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outlined),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Password required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Login Button with Resource state
                      SizedBox(
                        width: double.infinity,
                        child: bloc.authRepo.auth.when(
                          loading: () => ElevatedButton(
                            onPressed: null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Signing in...'),
                                ],
                              ),
                            ),
                          ),
                          error: (error, message) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Login failed: $error',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: bloc.login,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text('Try Again'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          data: (auth) => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: bloc.login,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('Sign In'),
                              ),
                            ),
                          ),
                          empty: () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: bloc.login,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('Sign In'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Demo credentials info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Demo Credentials',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Email: adn@gmail.com\nPassword: 1234',
                              style: theme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
