// mixin InheritedPatient {
//   final patientRM = RM.inject(() => Patient());
//   Iterable<PatientType> get patientTypes => patientTypesRepository.getAll();

//   // bool get editing => patient().editing;

//   void pickAndAddImageToThePatient() async {
//     final picked = await FilePicker.platform.pickFiles();
//     final path = picked?.files.first.path;
//     if (path != null) {
//       // ignore: unused_local_variable
//       final picture = Picture()..path = path;
//       // patient().pictures.add(picture);
//       // patient(patient());
//     }
//   }

//   void put(Patient patient) {
//     patientsRepository.put(patient);
//   }

//   void remove(int id) {
//     patientsRepository.remove(id);
//   }
// }
