import 'package:flutter/material.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/ui/patients/patient_page_2.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;

  const PatientTile({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (patient.email.isNotEmpty) Text('Email: ${patient.email}'),
            if (patient.contact.target?.mnp.isNotEmpty == true)
              Text('Phone: ${patient.contact.target!.mnp}'),
            Text('Age: ${patient.age}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PatientPage(patient.id),
            ),
          );
        },
      ),
    );
  }
}
