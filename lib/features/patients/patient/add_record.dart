import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patients/utils/architecture.dart';

class AddRecordView extends StatefulWidget {
  final int patientId;

  const AddRecordView({
    super.key,
    required this.patientId,
  });

  @override
  State<AddRecordView> createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  final Map<String, dynamic> _formData = {
    'date': DateTime.now(),
    'type': 'general',
    'notes': '',
    'followUpRequired': false,
    'followUpDate': null,
  };

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _formData['date'] = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void onFormSubmitted() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      logInfo('Submitting record: $_formData');
      Navigator.of(context).pop(true); // Return success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Patient Record',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Record Type
                DropdownButtonFormField<String>(
                  initialValue: _formData['type'],
                  decoration: const InputDecoration(
                    labelText: 'Record Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'general', child: Text('General Checkup')),
                    DropdownMenuItem(
                        value: 'followup', child: Text('Follow-up')),
                    DropdownMenuItem(value: 'test', child: Text('Test Result')),
                    DropdownMenuItem(
                        value: 'prescription', child: Text('Prescription')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _formData['type'] = value;
                      });
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Please select a record type' : null,
                ),
                const SizedBox(height: 16),

                // Date Picker
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Record Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please select a date' : null,
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  onSaved: (value) => _formData['notes'] = value ?? '',
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Please enter some notes'
                      : null,
                ),
                const SizedBox(height: 16),

                // Follow-up Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _formData['followUpRequired'],
                      onChanged: (value) {
                        setState(() {
                          _formData['followUpRequired'] = value ?? false;
                        });
                      },
                    ),
                    const Text('Schedule Follow-up'),
                  ],
                ),

                // Follow-up Date (conditionally shown)
                if (_formData['followUpRequired'] == true) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Follow-up Date',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              _formData['followUpDate'] = picked;
                            });
                          }
                        },
                      ),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text: _formData['followUpDate'] != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(_formData['followUpDate'] as DateTime)
                          : '',
                    ),
                    validator: (value) {
                      if (_formData['followUpRequired'] == true &&
                          _formData['followUpDate'] == null) {
                        return 'Please select a follow-up date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('CANCEL'),
                      ),
                    ),
                    Expanded(
                      child: FilledButton(
                        onPressed: onFormSubmitted,
                        child: const Text('SAVE RECORD'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
