import 'dart:async';

import 'package:forui/forui.dart';
import 'package:patients/domain/api/navigator.dart';
import 'package:patients/domain/api/patients_repository.dart';
import 'package:patients/ui/patients/add_patient_dialog.dart';
import 'package:patients/ui/patients/patient_tile.dart';
import 'package:patients/ui/patients/sort_and_filter.dart';

import '../../../main.dart';
import '../../../domain/models/patient.dart';

part 'patients_bloc.dart';

late PatientsBloc _patientsBloc;

class PatientsPage extends UI {
  const PatientsPage({super.key});
  @override
  void didMountWidget(BuildContext context) {
    _patientsBloc = PatientsBloc();
    super.didMountWidget(context);
  }

  @override
  void didUnmountWidget() {
    _patientsBloc.dispose();
    super.didUnmountWidget();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: 'Patients'.text(),
        prefixActions: [
          FButton.icon(
            onPress: () => navigator.back(),
            child: FIcon(FAssets.icons.x),
          ),
          FAvatar.raw(
            child: '${_patientsBloc.sorted.length}'.text(),
          ),
        ],
        suffixActions: [
          FButton.icon(
            onPress: () => _patientsBloc(ToggleFilterEvent()),
            child: FIcon(
              switch (_patientsBloc().filter) {
                FilterPatients.all => FAssets.icons.calendar,
                FilterPatients.today => FAssets.icons.filter,
                FilterPatients.last10 => FAssets.icons.tent,
              },
            ),
          ),
          FButton.icon(
            onPress: () => _patientsBloc(ToggleSortEvent()),
            child: FIcon(
              switch (_patientsBloc().sort) {
                SortPatients.date => FAssets.icons.arrowUpAZ,
                SortPatients.name => FAssets.icons.diameter,
              },
            ),
          ),
          FButton.icon(
            onPress: () => _patientsBloc(OpenNewPatientDialogEvent()),
            child: FIcon(FAssets.icons.plus),
          ),
        ],
      ),
      content: Column(
        children: [
          SortAndFilter(
            filter: _patientsBloc().filter,
            sort: _patientsBloc().sort,
            onFilterChanged: (filter) => ChangeFilterEvent(filter),
            onSortChanged: (sort) => ChangeSortEvent(sort),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _patientsBloc.sorted.length,
              itemBuilder: (context, index) {
                return PatientTile(
                  patient: _patientsBloc.sorted.elementAt(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
