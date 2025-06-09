import 'package:forui/forui.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/models/patient.dart';
// import 'package:patients/patients/patient/patient_page.dart';
import 'package:patients/ui/patients/patient_page.dart';

class PatientTile extends UI {
  final Patient patient;

  const PatientTile({super.key, required this.patient});
  @override
  Widget build(BuildContext context) {
    return FTile(
      prefixIcon: FAvatar.raw(
        child: Text(
          patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      title: Text(
        patient.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Text(
              'ID: ${patient.id}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            if (patient.complaints.isNotEmpty)
              Text(
                patient.complaints.split(' ').take(3).join(' '),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            Text(patient.date),
          ],
        ),
      ),
      suffixIcon: Icon(
        FIcons.arrowRight,
        size: 20,
      ),
      onPress: () {
        navigator.to(
          PatientPage(patient: patient),
        );
      },
    );
  }
}
