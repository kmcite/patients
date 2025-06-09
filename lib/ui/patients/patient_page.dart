import 'package:forui/forui.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/domain/models/patient_types.dart';
import 'package:patients/main.dart';
import 'package:patients/domain/api/navigator.dart';

class PatientBloc extends Bloc {
  final Patient patient;
  PatientBloc(this.patient);
  @override
  get initialState => ();
}

late PatientBloc patientBloc;

class PatientPage extends UI {
  final Patient patient;

  @override
  void didMountWidget(BuildContext context) {
    patientBloc = PatientBloc(patient);
    super.didMountWidget(context);
  }

  @override
  void didUnmountWidget() {
    patientBloc.dispose();
    super.didUnmountWidget();
  }

  const PatientPage({super.key, required this.patient});

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (patient.editing)
          FTextField(
            // initialText: patient().name,
            label: 'Name'.text(),
            // onChange: (value) => patient(patient()..name = value),
          )
        else
          FTile(title: const Text('Name'), suffixIcon: Text(patient.name)),
        const SizedBox(height: 8),

        // Age
        if (patient.editing)
          FTextField(
            initialText: patient.age.toStringAsFixed(0),
            label: 'Age (Years)'.text(),
            keyboardType: TextInputType.number,
            // onChange: (value) => patient().age = double.tryParse(value) ?? 0,
          )
        else
          FTile(
              title: const Text('Age'),
              suffixIcon: Text(patient.age.toStringAsFixed(0))),
        const SizedBox(height: 8),

        // Gender
        if (patient.editing)
          FButton.icon(
            child: Icon(
              patient.gender ? Icons.male : Icons.female,
            ),
            onPress: () {
              // patient(patient()..gender = !patient().gender);
            },
          ).pad()
        else
          FTile(
              title: const Text('Gender'),
              suffixIcon: Text(patient.gender ? 'Male' : 'Female')),

        // Presentation Date and Time
        FLabel(
          label: const Text('Presentation Date'),
          axis: Axis.vertical,
          child: FButton(
            onPress: () async {
              final time = await showDatePicker(
                context: RM.context!,
                initialDate: patient.timeOfPresentation,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
              );
              if (time != null) {
                // patient(patient()..timeOfPresentation = time);
              }
            },
            child: DateFormat('EEEE, d/MM/y')
                .format(
                  patient.timeOfPresentation,
                )
                .text(),
          ),
        ).pad(),

        // Attended
        if (patient.editing)
          FCheckbox(
            label: 'Attended'.text(),
            value: patient.attended,
            onChange: (value) {
              // patient(patient()..attended = value);
            },
          )
        else
          FTile(
            title: const Text('Attended'),
            suffixIcon: FCheckbox(value: patient.attended, onChange: null),
          ),
      ],
    );
  }

  Widget _buildDetailedInfoSection() {
    return Column(
      children: [
        patient.editing
            ? FTextField(
                label: const Text('Complaints'),
                initialText: patient.complaints,
                maxLines: null,
                onChange: (value) {
                  // patient(patient()..complaints = value);
                },
              )
            : FTile(
                title: const Text('Complaints'),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(patient.complaints.isNotEmpty
                      ? patient.complaints
                      : 'No complaints recorded.'),
                ),
              ),
        patient.editing
            ? FTextField(
                label: const Text('Examination'),
                initialText: patient.examination,
                maxLines: null,
                onChange: (value) {
                  // patient(patient()..examination = value);
                },
              )
            : FTile(
                title: const Text('Examination'),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(patient.examination.isNotEmpty
                      ? patient.examination
                      : 'No examination details recorded.'),
                ),
              ),
        patient.editing
            ? FTextField(
                label: const Text('Diagnosis'),
                initialText: patient.diagnosis,
                maxLines: null,
                onChange: (value) {
                  // patient(patient()..diagnosis = value);
                },
              )
            : FTile(
                title: const Text('Diagnosis'),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(patient.diagnosis.isNotEmpty
                      ? patient.diagnosis
                      : 'No diagnosis recorded.'),
                ),
              ),
        if (patient.editing)
          FTextField(
            label: 'Management'.text(),
            initialText: patient.management,
            maxLines: null,
            // onChange: (value) => patient(patient()..management = value),
          )
        else
          FTile(
            title: const Text('Management'),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(patient.management.isNotEmpty
                  ? patient.management
                  : 'No management plan recorded.'),
            ),
          ),
      ],
    );
  }

  Widget _buildPicturesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: patient.pictures.isNotEmpty
              ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: patient.pictures.length,
                    itemBuilder: (context, index) {
                      final picture = patient.pictures[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          picture.path,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
              : const Text('No pictures added.'),
        ),
        if (patient.editing)
          FButton(
            onPress: () {},
            child: const Text('Add Picture'),
          ),
      ],
    );
  }

  Widget _buildOtherInfoSection() {
    return patient.editing
        ? FTextField(
            label: 'Other Information'.text(),
            initialText: patient.other,
            maxLines: null,
            onChange: (value) => patient.other = value,
          )
        : FTile(
            title: const Text('Other Information'),
            subtitle: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(patient.other.isNotEmpty
                  ? patient.other
                  : 'No other information recorded.'),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: Text(patient.name.isNotEmpty ? patient.name : 'Details'),
        prefixes: [
          FButton.icon(
            onPress: navigator.back,
            child: Icon(FIcons.arrowLeft),
          ),
        ],
        suffixes: [
          FButton.icon(
            style: FButtonStyle.primary,
            onPress: () {
              // patient(patient()..editing = !patient().editing);
            },
            child: Icon(
              patient.editing ? FIcons.save : FIcons.pen,
            ),
          ),
          FButton.icon(
            style: FButtonStyle.destructive,
            onPress: () {
              // remove(patient().id);
              navigator.back();
            },
            child: Icon(FIcons.delete),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: 20),
            _buildDetailedInfoSection(),
            const SizedBox(height: 20),
            FButton(
              onPress: () async {
                final type = await navigator.toCupertinoDialog<PatientType>(
                  PatientTypeDialog(),
                );
                if (type != null) {
                  // patient(
                  //   patient()..patientType.target = type,
                  // );
                }
              },
              child: (patient.patientType.target?.type ?? 'N/A').text(),
            ),
            _buildPicturesSection(),
            const SizedBox(height: 20),
            _buildOtherInfoSection(),
          ],
        ),
      ),
    );
  }
}

class PatientTypeDialog extends UI {
  const PatientTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FDialog(
      direction: Axis.horizontal,
      title: const Text('Select Patient Type'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: patientTypesRepository().map(
          (type) {
            return FButton(
              style: FButtonStyle.primary,
              onPress:
                  // type.id == typeRM.state.id
                  //     ? null
                  //     :
                  () {
                // typeRM
                //   ..state = type
                //   ..notify();
              },
              child: type.type.text(),
            ).pad(all: 4);
          },
        ).toList(),
      ),
      actions: [
        // FButton.icon(
        //   style: FButtonStyle.primary,
        //   onPress: typeRM.state.id == 0
        //       ? null
        //       : () {
        //           navigator.back(typeRM.state);
        //         },
        //   child: 'Okay'.text(),
        // ),
        FButton.icon(
          style: FButtonStyle.destructive,
          onPress: () {
            navigator.back();
          },
          child: 'Cancel'.text(),
        ),
      ],
    );
  }
}
