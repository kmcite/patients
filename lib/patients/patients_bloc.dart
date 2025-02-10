import 'package:patients/patients/patients_repository.dart';

import '../main.dart';
import 'patient.dart';

enum FilterPatients {
  all,
  today,
  last10,
}

enum SortPatients {
  date,
  name,
}

class PatientsState {
  final List<Patient> patients;
  final FilterPatients filter;
  final SortPatients sort;
  PatientsState({
    this.patients = const [],
    this.filter = FilterPatients.all,
    this.sort = SortPatients.name,
  });
  @override
  String toString() {
    return 'PatientsState{patients: $patients, filter: $filter, sort: $sort}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientsState &&
          runtimeType == other.runtimeType &&
          patients == other.patients &&
          filter == other.filter &&
          sort == other.sort;
  @override
  int get hashCode => patients.hashCode ^ filter.hashCode ^ sort.hashCode;
  PatientsState copyWith({
    List<Patient>? patients,
    FilterPatients? filter,
    SortPatients? sort,
  }) {
    return PatientsState(
      patients: patients ?? this.patients,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
    );
  }
}

class PatientsBloc {
  late final patientsRM = RM.injectStream(
    () {
      return patientsRepository.watch().map(
        (query) {
          return PatientsState(
            patients: query,
            filter: state.filter,
            sort: state.sort,
          );
        },
      );
    },
    initialState: PatientsState(),
  );

  PatientsState get state => patientsRM.state;

  List<Patient> get patients => _applyFilterAndSort(
        state.patients,
        state.filter,
        state.sort,
      );

  void filterPatients(FilterPatients filter) {
    patientsRM.state = state.copyWith(filter: filter);
  }

  void sortPatients(SortPatients sort) {
    patientsRM.state = state.copyWith(sort: sort);
  }

  List<Patient> _applyFilterAndSort(
      List<Patient> patients, FilterPatients filter, SortPatients sort) {
    // First apply filter
    final filtered = switch (filter) {
      FilterPatients.all => patients,
      FilterPatients.today => patients
          .where((e) => e.timeOfPresentation.day == DateTime.now().day)
          .toList(),
      FilterPatients.last10 => patients.take(10).toList(),
    };

    // Then sort the filtered list
    return filtered.toList()
      ..sort(
        (a, b) {
          return switch (sort) {
            SortPatients.date =>
              a.timeOfPresentation.compareTo(b.timeOfPresentation),
            SortPatients.name => a.name.compareTo(b.name),
          };
        },
      );
  }

  int put(Patient patient) => patientsRepository.put(patient);
}

final patientsBloc = PatientsBloc();
