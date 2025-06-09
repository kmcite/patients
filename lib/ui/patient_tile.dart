import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:manager/manager.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/ui/patient_page.dart';
import 'package:patients/domain/models/patient.dart';

class PatientTile extends UI {
  final Patient patient;

  const PatientTile({super.key, required this.patient});
  @override
  Widget build(BuildContext context) {
    return FLabel(
      axis: Axis.vertical,
      label: patient.name.text(),
      description: Text(patient.complaints),
      child: FButton(
        onPress: () => navigator.to(
          PatientPage(patient.id),
        ),
        child: Icon(Icons.info),
      ),
    );
  }
}
