// import 'package:flutter/material.dart';
// import 'package:patients/domain/api/authentication_repository.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/utils/architecture.dart';
// import 'package:patients/ui/home.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class AuthenticationBloc extends Bloc {
//   late final authenticationRepository = watch<AuthenticationRepository>();

//   String email = 'adn@gmail.com';
//   String password = '1234';
//   void onEmailChange(String email) {
//     this.email = email;
//     notifyListeners();
//   }

//   void onPasswordChange(String password) {
//     this.password = password;
//     notifyListeners();
//   }

//   Future<void> login() async {
//     await authenticationRepository.login(email, password);

//     // Navigate to home if login successful
//     if (authenticationRepository.isAuthenticated) {
//       navigator.toReplacement(HomeView());
//     }
//   }
// }

// /// Login Page Widget
// class AuthenticationView extends Feature<AuthenticationBloc> {
//   const AuthenticationView({super.key});

//   @override
//   Widget build(BuildContext context, AuthenticationBloc controller) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Authentication'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           spacing: 8,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Logo/Header
//             Icon(
//               Icons.local_hospital,
//               size: 50,
//             ),
//             Text('Patients Management'),

//             // Email Field
//             TextFormField(
//               initialValue: controller.email,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 labelText: 'Email Address',
//                 prefixIcon: Icon(Icons.email_outlined),
//               ),
//               onChanged: controller.onEmailChange,
//             ),

//             // Password Field
//             TextFormField(
//               initialValue: controller.password,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 prefixIcon: Icon(Icons.lock_outlined),
//               ),
//               onChanged: controller.onPasswordChange,
//             ),

//             // Login Button
//             ElevatedButton(
//               onPressed: controller.login,
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 child: Text('Sign In'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
