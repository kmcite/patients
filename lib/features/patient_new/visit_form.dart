// lib/ui/patients/patient/patient_screen.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:patients/models/patient.dart';
import 'package:patients/repositories/patients_repository.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class VisitBloc extends Bloc<VisitForm> {
  late VisitsRepository visitsRepository = watch();
  late PatientsRepository patientsRepository = watch();
  List<PatientNew> get patients => patientsRepository.value;

  late final Visit _visit = widget.initialVisit ?? Visit();
  late final _dateFormat = DateFormat('MMM d, y - hh:mm a');
  late PatientNew? patient = widget.patient ?? _visit.patient.target;
  String get encounterType => _visit.encounterType;
  String get diagnosis => _visit.diagnosis;
  String get management => _visit.management;
  String get examination => _visit.examination;
  String get presentation => _visit.presentation;
  String get investigation => _visit.investigation;
  DateTime get when => _visit.when;
  String get formedWhen => _dateFormat.format(_visit.when);
  int? get patientId => patient?.id;

  PatientNew? getById(int id) {
    return null;

    // return patientsRepository.getById(id);
  }

  void onPatientChanged(int? patient) {
    if (patient == null) return;
    // final pt = patientsRepository.getById(patient);
    // _visit.patient.target = pt;
    notifyListeners();
  }

  void onEncounterTypeChanged(String encounterType) {
    _visit.encounterType = encounterType;
    notifyListeners();
  }

  void onDiagnosisChanged(String diagnosis) {
    _visit.diagnosis = diagnosis;
    notifyListeners();
  }

  void onManagementChanged(String management) {
    _visit.management = management;
    notifyListeners();
  }

  void onWhenChanged(DateTime when) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _visit.when,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_visit.when),
    );
    if (time != null) {
      final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _visit.when = newDateTime;
    }
    notifyListeners();
  }

  void onSaved() {
    // visitsRepository.put(_visit);
    navigator.back();
  }

  void onInvestigationChanged(String value) {
    _visit.investigation = value;
    notifyListeners();
  }

  void onPresentationChanged(String value) {
    _visit.presentation = value;
    notifyListeners();
  }

  void onExaminationChanged(String value) {
    _visit.examination = value;
    notifyListeners();
  }
}

class VisitForm extends Feature<VisitBloc> {
  final PatientNew? patient;
  final Visit? initialVisit;

  const VisitForm({
    super.key,
    this.patient,
    this.initialVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          initialVisit == null ? 'Add New Visit' : 'Edit Visit',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.onSaved,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            DropdownButtonFormField<int>(
              initialValue: controller.patientId,
              items: controller.patients
                  .map(
                    (p) => DropdownMenuItem(
                      value: p.id,
                      child: Text(controller.getById(p.id)?.name ?? ''),
                    ),
                  )
                  .toList(),
              onChanged: controller.onPatientChanged,
            ),
            // Date & Time Picker
            TextFormField(
              initialValue: controller.when.toString(),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date & Time',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                // controller._selectDateTime(context);
              },
            ),

            // Encounter Type
            DropdownButtonFormField<String>(
              initialValue: controller._visit.encounterType,
              decoration: const InputDecoration(
                labelText: 'Encounter Type',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'OPD',
                  child: Text('OPD'),
                ),
                DropdownMenuItem(
                  value: 'ER',
                  child: Text('Emergency Room'),
                ),
                DropdownMenuItem(
                  value: 'Ward',
                  child: Text('Ward'),
                ),
                DropdownMenuItem(
                  value: 'Follow-up',
                  child: Text('Follow-up'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller._visit.encounterType = value;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select encounter type';
                }
                return null;
              },
            ),

            // Diagnosis
            TextFormField(
              initialValue: controller.diagnosis,
              onChanged: (value) => controller.onDiagnosisChanged(value),
              decoration: const InputDecoration(
                labelText: 'Diagnosis',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            // Management
            TextFormField(
              initialValue: controller.management,
              onChanged: (value) => controller.onManagementChanged(value),
              decoration: const InputDecoration(
                labelText: 'Management',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            // Examination
            TextFormField(
              initialValue: controller.examination,
              onChanged: (value) => controller.onExaminationChanged(value),
              decoration: const InputDecoration(
                labelText: 'Examination Findings',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            // Presentation
            TextFormField(
              initialValue: controller.presentation,
              onChanged: (value) => controller.onPresentationChanged(value),
              decoration: const InputDecoration(
                labelText: 'Patient Presentation',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),

            // Investigation
            TextFormField(
              initialValue: controller.investigation,
              onChanged: (value) => controller.onInvestigationChanged(value),
              decoration: const InputDecoration(
                labelText: 'Investigations',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
