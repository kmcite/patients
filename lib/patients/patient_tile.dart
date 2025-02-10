import 'package:patients/main.dart';
import 'package:patients/navigation/navigation_bloc.dart';
import 'package:patients/patients/patient.dart';
import 'package:patients/patients/patient/patient_page.dart';

import 'patient/patient_bloc.dart';

class PatientTile extends UI {
  const PatientTile({super.key, required this.patient});
  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
          child: Text(
            patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '',
            style: TextStyle(
              color: Colors.white,
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
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              if (patient.complaints.isNotEmpty)
                Text(
                  patient.complaints.split(' ').take(3).join(' '),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              Text(patient.date),
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        onTap: () {
          navigator.to(
            PatientPage(
              patientBloc: PatientBloc(patient.id),
            ),
          );
        },
      ),
    );
  }
}
