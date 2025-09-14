import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:patients/utils/architecture.dart';

class AddDoctorDialogBloc extends Bloc {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  void okay(BuildContext context) {
    // TODO: Implement doctor creation logic
    // For now, just close the dialog
    Navigator.of(context).pop();
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

class AddDoctorDialog extends BlocWidget<AddDoctorDialogBloc> {
  const AddDoctorDialog({super.key});

  @override
  AddDoctorDialogBloc createBloc() => AddDoctorDialogBloc();

  @override
  Widget build(BuildContext context, AddDoctorDialogBloc bloc) {
    return FDialog(
      title: const Text('Create Doctor'),
      body: Column(
        children: [
          FTextField(
            label: const Text('Name'),
            controller: bloc.nameController,
          ),
          const SizedBox(height: 16),
          FTextField(
            label: const Text('Description'),
            controller: bloc.descriptionController,
          ),
          const SizedBox(height: 16),
          FTextField(
            label: const Text('Email'),
            controller: bloc.emailController,
          ),
          const SizedBox(height: 16),
          FTextField(
            label: const Text('Password'),
            controller: bloc.passwordController,
            obscureText: true,
          ),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton(
          style: FButtonStyle.primary(),
          onPress: () => bloc.okay(context),
          child: const Text('Create'),
        ),
        FButton(
          style: FButtonStyle.destructive(),
          onPress: () => bloc.cancel(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
