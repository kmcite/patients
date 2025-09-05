// import 'package:flutter/material.dart';
// import 'package:manager/manager.dart';
// import 'package:patients/domain/api/navigator.dart';
// import 'package:patients/ui/home_page.dart';

// class LoginPage extends UI {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: ListView(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               navigator.to(DoctorLoginPage());
//             },
//             child: 'Are you a doctor?'.text(),
//           ).pad(),
//           ElevatedButton(
//             onPressed: () {},
//             child: 'Are you a patient?'.text(),
//           ).pad(),
//         ],
//       ),
//     );
//   }
// }

// class DoctorLoginPage extends UI {
//   const DoctorLoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Doctor Login'),
//       ),
//       body: ListView(
//         children: [
//           TextField(
//             decoration: InputDecoration(labelText: 'Email'),
//           ).pad(),
//           TextField(
//             decoration: InputDecoration(labelText: 'Password'),
//             obscureText: true,
//           ).pad(),
//           ElevatedButton(
//             onPressed: () {
//               navigator.toAndRemoveUntil(HomePage());
//             },
//             child: 'Login'.text(),
//           ).pad(),
//         ],
//       ),
//     );
//   }
// }
