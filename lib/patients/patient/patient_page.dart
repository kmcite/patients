import 'package:patients/main.dart';
import '../../patient_types/patient_types_bloc.dart';
import '../patient.dart';
import 'patient_bloc.dart';

class PatientPage extends UI {
  final PatientBloc patientBloc;
  const PatientPage({super.key, required this.patientBloc});
  Patient get patient => patientBloc.get()!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(patient.name, textScaleFactor: 0.75),
        actions: [
          ageControl(),
        ],
      ),
      body: ListView(
        children: [
          patientInfoCard(context),
          if (patient.editing) patientNameField(),
          patientTextField(
            'Complaints',
            patient.complaints,
            (value) => patientBloc.set(patient..complaints = value),
          ),
          patientTextField(
            'Examination',
            patient.examination,
            (value) => patientBloc.set(patient..examination = value),
          ),
          patientTextField(
            'Management',
            patient.management,
            (value) => patientBloc.set(patient..management = value),
          ),
          patientTextField(
            'Diagnosis',
            patient.diagnosis,
            (value) => patientBloc.set(patient..diagnosis = value),
          ),
          patientTextField(
            'Other',
            patient.other,
            (value) => patientBloc.set(patient..other = value),
          ),
          patientTypeMenu(),
          patientAttendanceSwitch(),
          addPhotoButton(),
          patientPictureCarousel(context),
        ],
      ),
    );
  }

  Widget ageControl() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (patient.age > 0) {
              patientBloc.set(patient..age -= 1);
            }
          },
        ),
        InkWell(
          child: PopupMenuButton<int>(
            itemBuilder: (context) {
              List<PopupMenuEntry<int>> items = [];
              for (int i = 0; i <= 4; i++) {
                items.add(PopupMenuItem(value: i, child: Text('$i years')));
              }
              for (int i = 5; i <= 80; i += 5) {
                items.add(PopupMenuItem(value: i, child: Text('$i years')));
              }
              return items;
            },
            onSelected: (value) {
              patientBloc.set(patient..age = value.toDouble());
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(settings().borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '${patient.age.toInt()} years',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            if (patient.age < 120) {
              patientBloc.set(patient..age += 1);
            }
          },
        ).pad(right: 8),
      ],
    );
  }

  Widget patientInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: patient.gender
            ? Colors.blue
            : Colors.purple, // Optimized card color
        borderRadius: BorderRadius.circular(settings().borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20), // Increased padding for larger card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ID: ${patient.id}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold), // Adjusted font size
                    ).pad(),
                    IconButton(
                      icon: Icon(
                        patient.gender ? Icons.male : Icons.female,
                      ),
                      onPressed: () {
                        patientBloc.set(patient..gender = !patient.gender);
                      },
                    ).pad(),
                  ],
                ),
                Text(
                  patient.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic), // Larger font size
                ),
                SizedBox(height: 8), // Added spacing between elements
                Text(DateFormat('EEEE, d/MM/y')
                    .format(patient.timeOfPresentation)),
                patientDatePicker(context),
              ],
            ),
            Transform.scale(
              scale: 1.2,
              child: Switch(
                value: patient.editing,
                onChanged: (value) => patientBloc.set(patient..editing = value),
              ),
            ),
          ],
        ),
      ),
    ).pad();
  }

  Widget patientNameField() {
    return TextFormField(
      initialValue: patient.name,
      onChanged: (value) {
        patientBloc.set(patient..name = value);
      },
      decoration: InputDecoration(
        labelText: 'Patient Name',
        hintText: 'Enter patient\'s full name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    ).pad();
  }

  Widget patientDatePicker(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.date_range, color: Colors.white),
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: patient.timeOfPresentation,
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          patientBloc.set(patient..timeOfPresentation = date);
        }
      },
    );
  }

  Widget patientTypeMenu() {
    return Row(
      children: [
        Text(patient.patientType.target?.type ?? 'N/A').pad(),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return patientTypesBloc.patientTypes.map(
              (type) {
                return PopupMenuItem(
                  enabled: type.id != patient.patientType.target?.id,
                  value: type,
                  child: Text(type.type),
                );
              },
            ).toList();
          },
          onSelected: (value) {
            patientBloc.set(patient..patientType.target = value);
          },
        ),
      ],
    ).pad().card().pad();
  }

  Widget patientAttendanceSwitch() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Patient Attended'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch(
                value: patient.attended,
                onChanged: (value) =>
                    patientBloc.set(patient..attended = value),
              ),
              Text(
                patient.attended
                    ? 'Patient has attended'
                    : 'Patient has not attended yet',
                style: TextStyle(
                    fontSize: 12,
                    color: patient.attended ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addPhotoButton() {
    return IconButton(
      onPressed: () => patientBloc.pickAndAddImageToThePatient(),
      icon: Icon(Icons.add_a_photo),
    ).pad();
  }

  Widget patientPictureCarousel(BuildContext context) {
    if (patient.pictures.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: Text('No pictures available')),
      );
    }

    return SizedBox(
      height: 200,
      child: CarouselView(
        onTap: (value) {
          patientBloc.set(patient..pictures.removeAt(value));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(settings().borderRadius),
        ),
        itemExtent: MediaQuery.of(context).size.width * 0.6,
        children: patient.pictures.map(
          (picture) {
            return Card(
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(settings().borderRadius),
                child: Image.file(
                  File(picture.path),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget patientTextField(
      String label, String value, Function(String) onChanged) {
    return patientBloc.editing
        ? TextFormField(
            initialValue: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              hintText: "Enter patient's $label",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.help),
            ),
            minLines: 5,
            maxLines: 10,
          ).pad()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "${label.toUpperCase()}:".text(),
                Text(
                  value,
                  style: TextStyle(fontSize: 16), // Adjust the font size here
                ),
              ],
            ),
          ).pad();
  }

  Widget patientInfoText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 16), // Adjust the font size here
      ),
    );
  }
}
