import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:patients/domain/models/appointment.dart';
import 'package:patients/utils/architecture.dart';

@injectable
class AppointmentsBloc extends Bloc<AppointmentsPage> {
  void onAppointmentAdded(Appointment appointment) {}
}

class AppointmentsPage extends Feature<AppointmentsBloc> {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: const Center(
        child: Text('Appointments Page - Coming Soon'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.onAppointmentAdded(Appointment()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
