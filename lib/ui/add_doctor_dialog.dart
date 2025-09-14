import 'package:forui/forui.dart';

import '../main.dart';

class AddDoctorDialogBloc extends Bloc {
  // final nameRM = RM.injectTextEditing();
  // final descriptionRM = RM.injectTextEditing();
  // final passwordRM = RM.injectTextEditing();
  // final emailRM = RM.injectTextEditing();

  void okay() {
    // final doctor = Doctor()
    //   ..name = nameRM.text
    //   ..description = descriptionRM.text
    //   ..password = passwordRM.text
    //   ..email = emailRM.text;
    // final isEmailTaken = doctorsRepository.getAll().any(
    //       (doctor) {
    //         return doctor.email == emailRM.text;
    //       },
    //     ) ||
    //     patientsRepository.getAll().any(
    //       (pt) {
    //         return pt.email == emailRM.text;
    //       },
    //     );
    // if (!isEmailTaken) {
    //   doctorsRepository.put(doctor);
    // } else {
    //   scaffold.showSnackBar(
    //     SnackBar(
    //       content: '${emailRM.text} is already taken'.text(),
    //     ),
    //   );
    // }
    // cancel();
  }

  void cancel() {
    navigator.back();
  }
}

class AddDoctorDialog extends Feature<AddDoctorDialogBloc> {
  const AddDoctorDialog({super.key});

  @override
  Widget build(BuildContext context, controller) {
    return FDialog(
      title: 'Create Doctor'.text(),
      body: Column(
        children: [
          // FTextField(
          //   label: 'name'.text(),
          //   controller: nameRM.controller,
          // ),
          // FTextField(
          //   label: 'description'.text(),
          //   controller: descriptionRM.controller,
          // ),
          // FTextField(
          //   label: 'email'.text(),
          //   controller: emailRM.controller,
          // ),
          // FTextField(
          //   label: 'password'.text(),
          //   controller: passwordRM.controller,
          // ),
        ],
      ),
      direction: Axis.horizontal,
      actions: [
        // FButton.icon(
        //   style: FButtonStyle.primary,
        //   onPress: okay,
        //   child: 'Okay'.text(),
        // ),
        // FButton.icon(
        //   style: FButtonStyle.destructive,
        //   onPress: cancel,
        //   child: 'Cancel'.text(),
        // ),
      ],
    );
  }

  @override
  AddDoctorDialogBloc create() {
    throw UnimplementedError();
  }
}
