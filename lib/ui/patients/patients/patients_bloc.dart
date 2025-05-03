part of 'patients_page.dart';

/// STATE
typedef PatientsState = ({
  SortPatients sort,
  FilterPatients filter,
  Iterable<Patient> patients,
});

extension on PatientsState {
  PatientsState copyWith({
    SortPatients? sort,
    FilterPatients? filter,
    Iterable<Patient>? patients,
  }) {
    return (
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
      patients: patients ?? this.patients,
    );
  }
}

/// EVENTS
class PatientsEvent {}

class ToggleFilterEvent extends PatientsEvent {}

class ChangeFilterEvent extends PatientsEvent {
  final FilterPatients filter;
  ChangeFilterEvent(this.filter);
}

class ToggleSortEvent extends PatientsEvent {}

class ChangeSortEvent extends PatientsEvent {
  final SortPatients sort;
  ChangeSortEvent(this.sort);
}

class UpdatePatientEvent extends PatientsEvent {
  final Patient patient;
  UpdatePatientEvent(this.patient);
}

class RemovePatientEvent extends PatientsEvent {
  final int id;
  RemovePatientEvent(this.id);
}

class OpenNewPatientDialogEvent extends PatientsEvent {}

/// BLOC
class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  StreamSubscription<Iterable<Patient>>? _subscription;
  PatientsBloc() {
    on<ChangeFilterEvent>(
      (event) {
        emit(
          state.copyWith(filter: event.filter),
        );
      },
    );
    on<OpenNewPatientDialogEvent>((_) {
      navigator.toDialog(AddPatientPage());
    });
    on<ToggleFilterEvent>(
      (event) {
        emit(
          state.copyWith(
            filter: switch (state.filter) {
              FilterPatients.all => FilterPatients.today,
              FilterPatients.today => FilterPatients.last10,
              FilterPatients.last10 => FilterPatients.all,
            },
          ),
        );
      },
    );
    on<ToggleSortEvent>(
      (event) {
        emit(
          state.copyWith(
            sort: switch (state.sort) {
              SortPatients.date => SortPatients.name,
              SortPatients.name => SortPatients.date,
            },
          ),
        );
      },
    );
    on<ChangeSortEvent>(
      (event) {
        emit(
          state.copyWith(sort: event.sort),
        );
      },
    );
    on<UpdatePatientEvent>(
      (event) => patientsRepository(event.patient),
    );
    on<RemovePatientEvent>(
      (event) => patientsRepository.remove(event.id),
    );
    _subscription = patientsRepository.watch().listen(
      (patients) {
        emit(
          state.copyWith(patients: patients),
        );
      },
    );
  }

  Iterable<Patient> get filtered {
    return switch (state.filter) {
      FilterPatients.all => state.patients,
      FilterPatients.today => state.patients.where(
          (patient) {
            return patient.timeOfPresentation.day == DateTime.now().day;
          },
        ),
      FilterPatients.last10 => state.patients.take(10),
    };
  }

  Iterable<Patient> get sorted {
    return filtered.toList()
      ..sort(
        (a, b) {
          return switch (state.sort) {
            SortPatients.date =>
              b.timeOfPresentation.compareTo(a.timeOfPresentation),
            SortPatients.name => b.name.compareTo(a.name),
          };
        },
      );
  }

  Patient? get(int id) {
    return state.patients.where((patient) => patient.id == id).firstOrNull;
  }

  @override
  get initialState {
    return (
      sort: SortPatients.name,
      filter: FilterPatients.all,
      patients: patientsRepository(),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
