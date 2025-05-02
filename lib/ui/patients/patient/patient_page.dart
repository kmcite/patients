import 'package:patients/domain/models/patient.dart';
import 'package:patients/main.dart';
import 'package:patients/ui/patients/inherited_patient.dart';

class PatientPage extends UI with InheritedPatient {
  // ignore: prefer_typing_uninitialized_variables
  static var name;

  PatientPage({super.key, required int id});

  @override
  Widget build(BuildContext context) {
    Patient patient([Patient? value]) {
      if (value != null) {
        patientRM(context)
          ..state = value
          ..notify();
      }
      return patientRM.of(context);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (patient().age > 0) {
                    patient(patient()..age -= 1);
                  }
                },
              ),
              InkWell(
                child: PopupMenuButton<int>(
                  itemBuilder: (context) {
                    List<PopupMenuEntry<int>> items = [];
                    for (int i = 0; i <= 4; i++) {
                      items.add(
                          PopupMenuItem(value: i, child: Text('$i years')));
                    }
                    for (int i = 5; i <= 80; i += 5) {
                      items.add(
                          PopupMenuItem(value: i, child: Text('$i years')));
                    }
                    return items;
                  },
                  onSelected: (value) {
                    patient(patient()..age = value.toDouble());
                  },
                  shape: RoundedRectangleBorder(
                      // borderRadius: BorderRadius.circular(settings().borderRadius),
                      ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${patient().age.toInt()} years',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (patient().age < 120) {
                    patient(patient()..age += 1);
                  }
                },
              ).pad(right: 8),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          patientTypeMenu(context),
          patientAttendanceSwitch(context),
          addPhotoButton(),
          patientPictureCarousel(context),
        ],
      ),
    );
  }

  Widget patientNameField(BuildContext context) {
    Patient patient([Patient? value]) {
      if (value != null) {
        patientRM(context)
          ..state = value
          ..notify();
      }
      return patientRM.of(context);
    }

    return TextFormField(
      initialValue: patient().name,
      onChanged: (value) {
        patient(patient()..name = value);
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

  Widget patientTypeMenu(BuildContext context) {
    Patient patient([Patient? value]) {
      if (value != null) {
        patientRM(context)
          ..state = value
          ..notify();
      }
      return patientRM.of(context);
    }

    return Row(
      children: [
        Text(patient().patientType.target?.type ?? 'N/A').pad(),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return patientTypes.map(
              (type) {
                return PopupMenuItem(
                  enabled: type.id != patient().patientType.target?.id,
                  value: type,
                  child: Text(type.type),
                );
              },
            ).toList();
          },
          onSelected: (value) {
            patient(patient()..patientType.target = value);
          },
        ),
      ],
    ).pad().card().pad();
  }

  Widget patientAttendanceSwitch(BuildContext context) {
    Patient patient([Patient? value]) {
      if (value != null) {
        patientRM(context)
          ..state = value
          ..notify();
      }
      return patientRM.of(context);
    }

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
                value: patient().attended,
                onChanged: (value) => patient(patient()..attended = value),
              ),
              Text(
                patient().attended
                    ? 'Patient has attended'
                    : 'Patient has not attended yet',
                style: TextStyle(
                    fontSize: 12,
                    color: patient().attended ? Colors.green : Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addPhotoButton() {
    return IconButton(
      onPressed: () => pickAndAddImageToThePatient(),
      icon: Icon(Icons.add_a_photo),
    ).pad();
  }

  Widget patientPictureCarousel(BuildContext context) {
    Patient patient([Patient? value]) {
      if (value != null) {
        patientRM(context)
          ..state = value
          ..notify();
      }
      return patientRM.of(context);
    }

    if (patient().pictures.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: Text('No pictures available')),
      );
    }

    return SizedBox(
      height: 200,
      child: CarouselView(
        onTap: (value) {
          patient(patient()..pictures.removeAt(value));
        },
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(settings().borderRadius),
            ),
        itemExtent: MediaQuery.of(context).size.width * 0.6,
        children: patient().pictures.map(
          (picture) {
            return Card(
              elevation: 4,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(settings().borderRadius),
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
    String label,
    String value,
    Function(String) onChanged, [
    bool editing = false,
  ]) {
    return editing
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
