import 'package:forui/forui.dart';
import 'package:patients/_dermatosis/domain/models/patient.dart';
import 'package:patients/_dermatosis/features/patients/patient_page.dart';
import 'package:patients/_dermatosis/main.dart';
import 'package:patients/_dermatosis/navigator.dart';

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
        label: Icon(Icons.info),
      ),
    );
  }
}
