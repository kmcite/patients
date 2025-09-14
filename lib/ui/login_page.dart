import 'package:flutter/material.dart';
import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/utils/architecture.dart';
import 'package:patients/ui/home/home_page.dart';

/// Login Bloc - handles login logic and form state
class LoginBloc extends Bloc {
  late final AuthenticationRepository authRepo;
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
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
class LoginPage extends BlocWidget<LoginBloc> {
  const LoginPage({super.key});

  @override
  LoginBloc createBloc() => LoginBloc();

  @override
  Widget build(BuildContext context, LoginBloc bloc) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: bloc.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: bloc.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Password required';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Login Button with Resource state
              SizedBox(
                width: double.infinity,
                child: bloc.authRepo.auth.when(
                  loading: () => const ElevatedButton(
                    onPressed: null,
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, message) => Column(
                    children: [
                      Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: bloc.login,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  data: (auth) => ElevatedButton(
                    onPressed: bloc.login,
                    child: const Text('Login'),
                  ),
                  empty: () => ElevatedButton(
                    onPressed: bloc.login,
                    child: const Text('Login'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
