import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/patients/add_patient_dialog.dart';
import 'package:patients/ui/patients/patients_bloc.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});
  static const name = 'patients';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            navigator.to(HomePage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('patients'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigator.to(AddPatientPage()),
        child: const Icon(Icons.add),
      ),
      body: patientsBloc.patients.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const FaIcon(
                  FontAwesomeIcons.peopleGroup,
                  size: 150,
                ),
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: patientsBloc.patients.map(
                (patient) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColorLight,
                        child: Text(
                          patient.age.toString(),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      onTap: () {
                        // context.goNamed(PatientPage.name, extra: patient.id);
                      },
                      title: Text(
                        patient.name,
                        style: theme.textTheme.titleSmall,
                        textScaleFactor: 1.2,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
    );
  }
}
