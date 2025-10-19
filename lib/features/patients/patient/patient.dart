// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';
// import 'package:patients/repositories/patients_repository.dart';
// import 'package:patients/models/patient.dart';
// import 'package:patients/features/patients/edit_patient.dart';
// import 'package:patients/features/patients/patient/add_record.dart';
// import 'package:patients/features/patients/patient/information_row.dart';
// import 'package:patients/features/patients/patient/no_patient.dart';
// import 'package:patients/features/patients/patient/section.dart';
// import 'package:patients/utils/architecture.dart';

// @injectable
// class PatientBloc extends Bloc<PatientPage> {
//   late final PatientsRepository patientsRepository = watch();
//   late Patient? patient = widget.patient;

//   void _loadPatient(int id) {
//     // patient = patientsRepository.getById(id);
//     notifyListeners();
//   }

//   void updatePatient() {
//     if (patient != null) {
//       // patientsRepository.put(patient!);
//     }
//   }

//   void onRefreshed() {
//     if (patient != null) {
//       _loadPatient(patient!.id);
//     }
//   }

//   /// HELPERS
//   String _formatPhone(Contact? contact) {
//     if (contact == null || contact.mnp.isEmpty) return 'Not set';
//     return '${contact.phoneCode} ${contact.mnp}';
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   String _formatAddress(Address address) {
//     final parts = <String>[];
//     if (address.town.isNotEmpty) parts.add(address.town);
//     if (address.city.isNotEmpty) parts.add(address.city);
//     if (address.province.isNotEmpty) parts.add(address.province);
//     if (address.country.isNotEmpty) parts.add(address.country);
//     return parts.join(', ');
//   }
// }

// class PatientPage extends Feature<PatientBloc> {
//   final Patient patient;

//   const PatientPage({super.key, required this.patient});

//   @override
//   Widget build(BuildContext context) {
//     final patient = controller.patient;
//     if (patient == null) return NoPatientView();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(patient.name),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: controller.onRefreshed,
//             tooltip: 'Refresh',
//           ),
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // navigator.to(EditPatientView(patient: patient));
//             },
//             tooltip: 'Edit Patient',
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async => controller.onRefreshed(),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             spacing: 8,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SectionView(
//                 title: 'Basic Info',
//                 icon: Icons.person,
//                 children: [
//                   InformationRow(label: 'Name', value: patient.name),
//                   InformationRow(
//                     label: 'Gender',
//                     value: patient.gender ? 'Male' : 'Female',
//                   ),
//                   InformationRow(label: 'Age', value: '${patient.age} years'),
//                   if (patient.dateOfBirth != null)
//                     InformationRow(
//                       label: 'DOB',
//                       value: controller._formatDate(patient.dateOfBirth!),
//                     ),
//                   InformationRow(
//                     label: 'Type',
//                     value: patient.patientType.target?.type ?? 'N/A',
//                   ),
//                 ],
//               ),
//               SectionView(
//                 title: 'Contact',
//                 icon: Icons.contact_phone,
//                 children: [
//                   InformationRow(label: 'Email', value: patient.email),
//                   InformationRow(
//                     label: 'Phone',
//                     value: controller._formatPhone(patient.contact.target),
//                   ),
//                   if (patient.address.target != null)
//                     InformationRow(
//                       label: 'Address',
//                       value: controller._formatAddress(patient.address.target!),
//                     ),
//                 ],
//               ),
//               SectionView(
//                 title: 'Medical Information',
//                 icon: Icons.medical_information,
//                 children: [
//                   InformationRow(
//                     label: 'Blood Group',
//                     value: patient.bloodGroup.isNotEmpty
//                         ? patient.bloodGroup
//                         : 'Not specified',
//                   ),
//                   InformationRow(
//                     label: 'Allergies',
//                     value: patient.allergies.isNotEmpty
//                         ? patient.allergies
//                         : 'None reported',
//                   ),
//                   InformationRow(
//                     label: 'Chronic Conditions',
//                     value: patient.chronicConditions.isNotEmpty
//                         ? patient.chronicConditions
//                         : 'None reported',
//                   ),
//                   InformationRow(
//                     label: 'Current Medications',
//                     value: patient.currentMedications.isNotEmpty
//                         ? patient.currentMedications
//                         : 'None reported',
//                   ),
//                 ],
//               ),
//               SectionView(
//                 title: 'Emergency Contact',
//                 icon: Icons.emergency,
//                 children: [
//                   InformationRow(
//                     label: 'Name',
//                     value: patient.emergencyContactName.isNotEmpty
//                         ? patient.emergencyContactName
//                         : 'Not provided',
//                   ),
//                   InformationRow(
//                     label: 'Phone',
//                     value: patient.emergencyContactPhone.isNotEmpty
//                         ? patient.emergencyContactPhone
//                         : 'Not provided',
//                   ),
//                   InformationRow(
//                     label: 'Relationship',
//                     value: patient.emergencyContactRelation.isNotEmpty
//                         ? patient.emergencyContactRelation
//                         : 'Not specified',
//                   ),
//                 ],
//               ),
//               SectionView(
//                 title: 'Visit Information',
//                 icon: Icons.medical_services,
//                 children: [
//                   InformationRow(
//                     label: 'Status',
//                     value: patient.outComeStatus.toString().split('.').last,
//                   ),
//                   InformationRow(
//                     label: 'Presenting Complaint',
//                     value: patient.complaints.isNotEmpty
//                         ? patient.complaints
//                         : 'Not specified',
//                   ),
//                   InformationRow(
//                     label: 'Examination',
//                     value: patient.examination.isNotEmpty
//                         ? patient.examination
//                         : 'Not documented',
//                   ),
//                   InformationRow(
//                     label: 'Diagnosis',
//                     value: patient.diagnosis.isNotEmpty
//                         ? patient.diagnosis
//                         : 'Pending',
//                   ),
//                   InformationRow(
//                     label: 'Management',
//                     value: patient.management.isNotEmpty
//                         ? patient.management
//                         : 'Not specified',
//                   ),
//                 ],
//               ),
//               if (patient.insuranceProvider.isNotEmpty ||
//                   patient.insuranceNumber.isNotEmpty)
//                 SectionView(
//                   title: 'Insurance Information',
//                   icon: Icons.credit_card,
//                   children: [
//                     if (patient.insuranceProvider.isNotEmpty)
//                       InformationRow(
//                         label: 'Provider',
//                         value: patient.insuranceProvider,
//                       ),
//                     if (patient.insuranceNumber.isNotEmpty)
//                       InformationRow(
//                         label: 'Policy Number',
//                         value: patient.insuranceNumber,
//                       ),
//                   ],
//                 ),
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // Add action for adding a new visit/record
//                   },
//                   icon: const Icon(Icons.add_circle_outline),
//                   label: const Text('Add New Visit Record'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           navigator.toDialog(
//             AddRecordView(
//               patientId: patient.id,
//             ),
//           );
//         },
//         icon: const Icon(Icons.add),
//         label: const Text('Add Record'),
//       ),
//     );
//   }
// }
