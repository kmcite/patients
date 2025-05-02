import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/domain/models/patient.dart';
import 'package:patients/main.dart';

enum FilterPatients {
  all,
  today,
  last10,
}

enum SortPatients {
  date,
  name;

  String get description {
    return switch (this) {
      SortPatients.date => 'By date',
      SortPatients.name => 'By name',
    };
  }
}

mixin class SortAndFilterBloc {
  Iterable<Patient> get _patients => patientsRepository.getAll();

  SortPatients get sort => sortRM.state.firstOrNull ?? SortPatients.name;
  FilterPatients get filter => filterRM.state.firstOrNull ?? FilterPatients.all;
  final sortRM = RM.inject(() => {SortPatients.date});
  final filterRM = RM.inject(() => {FilterPatients.all});

  Iterable<Patient> get patients {
    final filtered = switch (filter) {
      FilterPatients.all => _patients,
      FilterPatients.today => _patients.where(
          (patient) {
            return patient.timeOfPresentation.day == DateTime.now().day;
          },
        ),
      FilterPatients.last10 => _patients.take(10),
    };

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

  void put(Patient p) => patientsRepository.put(p);
}

class SortAndFilter extends UI with SortAndFilterBloc {
  SortAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              child: 'F'.text(),
            ).pad(all: 4),
            ...FilterPatients.values.map(
              (eachfilter) {
                return FilterChip(
                  label: Text(
                    eachfilter
                        .toString()
                        .split('.')
                        .last
                        .replaceAll('last', 'Last ')
                        .replaceAll('today', 'Today\'s ')
                        .replaceAll('all', 'All'),
                  ),
                  selected: filter == eachfilter,
                  onSelected: (value) {
                    if (value) {
                      filterRM.state = {eachfilter};
                    } else {
                      filterRM.state = {};
                    }
                  },
                ).pad(all: 4);
              },
            )
          ],
        ),
        Row(
          children: [
            CircleAvatar(
              child: 'S'.text(),
            ).pad(all: 4),
            ...SortPatients.values.map(
              (eachfilter) {
                return FilterChip(
                  label: Text(
                    eachfilter.description,
                  ),
                  selected: sort == eachfilter,
                  onSelected: (value) {
                    if (value) {
                      sortRM.state = {eachfilter};
                    } else {
                      sortRM.state = {};
                    }
                  },
                ).pad(all: 4);
              },
            )
          ],
        ),
      ],
    );
  }
}
