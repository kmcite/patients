// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:package_info_plus/package_info_plus.dart' as _i655;

import '../features/app_drawer.dart' as _i130;
import '../features/appointments.dart' as _i993;
import '../features/authentication.dart' as _i418;
import '../features/home.dart' as _i952;
import '../features/imageries.dart' as _i674;
import '../features/investigations.dart' as _i127;
import '../features/new_quick_patient.dart' as _i265;
import '../features/patient_new/edit_patient.dart' as _i899;
import '../features/patient_new/patient_new.dart' as _i727;
import '../features/patient_new/visit_form.dart' as _i296;
import '../features/patient_new/visits.dart' as _i691;
import '../features/patient_types/patient_types.dart' as _i853;
import '../features/patients/edit_patient.dart' as _i465;
import '../features/patients/new_patient.dart' as _i561;
import '../features/patients/patients.dart' as _i294;
import '../features/personal/duty_roster.dart' as _i359;
import '../features/personal/roster_table.dart' as _i1014;
import '../features/personal/upcoming_duties.dart' as _i1069;
import '../features/personal/user.dart' as _i830;
import '../features/search.dart' as _i385;
import '../features/settings.dart' as _i738;
import '../main.dart' as _i214;
import '../objectbox.g.dart' as _i179;
import '../repositories/duties_repository.dart' as _i875;
import '../repositories/hospital_repository.dart' as _i384;
import '../repositories/navigator.dart' as _i1024;
import '../repositories/patients_repository.dart' as _i926;
import '../repositories/settings_repository.dart' as _i2;
import '../repositories/upcoming_duty_finder.dart' as _i903;
import '../repositories/user_repository.dart' as _i640;
import 'object_box.dart' as _i620;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dependencies = _$Dependencies();
    gh.factory<_i130.AppDrawerBloc>(() => _i130.AppDrawerBloc());
    gh.factory<_i993.AppointmentsBloc>(() => _i993.AppointmentsBloc());
    gh.factory<_i418.AuthenticationBloc>(() => _i418.AuthenticationBloc());
    gh.factory<_i952.HomeBloc>(() => _i952.HomeBloc());
    gh.factory<_i674.ImageriesBloc>(() => _i674.ImageriesBloc());
    gh.factory<_i127.InvestigationsBloc>(() => _i127.InvestigationsBloc());
    gh.factory<_i265.NewQuickPatientBloc>(() => _i265.NewQuickPatientBloc());
    gh.factory<_i899.EditPatientBloc>(() => _i899.EditPatientBloc());
    gh.factory<_i727.PatientNewBloc>(() => _i727.PatientNewBloc());
    gh.factory<_i296.VisitBloc>(() => _i296.VisitBloc());
    gh.factory<_i691.VisitsBloc>(() => _i691.VisitsBloc());
    gh.factory<_i853.PatientTypesBloc>(() => _i853.PatientTypesBloc());
    gh.factory<_i465.EditPatientBloc>(() => _i465.EditPatientBloc());
    gh.factory<_i561.NewPatientBloc>(() => _i561.NewPatientBloc());
    gh.factory<_i294.PatientsBloc>(() => _i294.PatientsBloc());
    gh.factory<_i359.DutyRosterBloc>(() => _i359.DutyRosterBloc());
    gh.factory<_i1014.RosterTableBloc>(() => _i1014.RosterTableBloc());
    gh.factory<_i1069.UpcomingDutiesBloc>(() => _i1069.UpcomingDutiesBloc());
    gh.factory<_i830.UserBloc>(() => _i830.UserBloc());
    gh.factory<_i385.SearchBloc>(() => _i385.SearchBloc());
    gh.factory<_i738.SettingsBloc>(() => _i738.SettingsBloc());
    gh.factory<_i214.ThemeModeBloc>(() => _i214.ThemeModeBloc());
    await gh.factoryAsync<_i655.PackageInfo>(
      () => dependencies.appInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i179.Store>(
      () => dependencies.store,
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<dynamic>>(
      () => dependencies.box,
      preResolve: true,
    );
    gh.singleton<_i875.DutiesRepository>(() => _i875.DutiesRepository());
    gh.singleton<_i384.HospitalRepository>(() => _i384.HospitalRepository());
    gh.singleton<_i1024.Navigation>(() => _i1024.Navigation());
    gh.singleton<_i926.PatientsRepository>(() => _i926.PatientsRepository());
    gh.singleton<_i926.VisitsRepository>(() => _i926.VisitsRepository());
    gh.singleton<_i2.SettingsRepository>(
      () => _i2.SettingsRepository(),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i903.UpcomingDutyFinder>(() => _i903.UpcomingDutyFinder());
    gh.singleton<_i640.UserRepository>(() => _i640.UserRepository());
    return this;
  }
}

class _$Dependencies extends _i620.Dependencies {}
