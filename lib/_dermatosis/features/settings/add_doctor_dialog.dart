import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:manager/manager.dart';
import 'package:patients/_dermatosis/domain/api/doctors_repository.dart';
import 'package:patients/_dermatosis/domain/api/patients_repository.dart';
import 'package:patients/_dermatosis/domain/models/doctor.dart';
import 'package:patients/_dermatosis/navigator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

mixin AddDoctorDialogBloc {
  final nameRM = RM.injectTextEditing();
  final descriptionRM = RM.injectTextEditing();
  final passwordRM = RM.injectTextEditing();
  final emailRM = RM.injectTextEditing();

  void okay() {
    final doctor = Doctor()
      ..name = nameRM.text
      ..description = descriptionRM.text
      ..password = passwordRM.text
      ..email = emailRM.text;
    final isEmailTaken = doctorsRepository.getAll().any(
          (doctor) {
            return doctor.email == emailRM.text;
          },
        ) ||
        patientsRepository.getAll().any(
          (pt) {
            return pt.email == emailRM.text;
          },
        );
    if (!isEmailTaken) {
      doctorsRepository.put(doctor);
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content: '${emailRM.text} is already taken'.text(),
        ),
      );
    }
    cancel();
  }

  void cancel() {
    navigator.back();
  }
}

class AddDoctorDialog extends UI with AddDoctorDialogBloc {
  AddDoctorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FDialog(
      title: 'Create Doctor'.text(),
      body: Column(
        children: [
          FTextField(
            label: 'name'.text(),
            controller: nameRM.controller,
          ),
          FTextField(
            label: 'description'.text(),
            controller: descriptionRM.controller,
          ),
          FTextField(
            label: 'email'.text(),
            controller: emailRM.controller,
          ),
          FTextField(
            label: 'password'.text(),
            controller: passwordRM.controller,
          ),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        FButton.icon(
          style: FButtonStyle.primary,
          onPress: okay,
          child: 'Okay'.text(),
        ),
        FButton.icon(
          style: FButtonStyle.destructive,
          onPress: cancel,
          child: 'Cancel'.text(),
        ),
      ],
    );
  }
}
