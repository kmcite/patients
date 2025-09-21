// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

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

import '../domain/api/authentication_repository.dart' as _i315;
import '../domain/api/duties_repository.dart' as _i74;
import '../domain/api/hospital_repository.dart' as _i744;
import '../domain/api/imageries_repository.dart' as _i324;
import '../domain/api/investigations.dart' as _i314;
import '../domain/api/navigator.dart' as _i293;
import '../domain/api/patients_repository.dart' as _i729;
import '../domain/api/pictures_repository.dart' as _i604;
import '../domain/api/settings_repository.dart' as _i239;
import '../domain/api/upcoming_duty_finder.dart' as _i139;
import '../domain/api/user_repository.dart' as _i408;
import '../main.dart' as _i214;
import '../objectbox.g.dart' as _i179;
import '../ui/new_quick_patient.dart' as _i1027;
import '../ui/app_drawer.dart' as _i9;
import '../ui/appointments.dart' as _i243;
import '../ui/authentication.dart' as _i148;
import '../ui/home.dart' as _i53;
import '../ui/imageries.dart' as _i423;
import '../ui/investigations.dart' as _i404;
import '../ui/medications.dart' as _i389;
import '../ui/patient_types/patient_types.dart' as _i257;
import '../ui/patients/new_patient.dart' as _i566;
import '../ui/patients/patient.dart' as _i192;
import '../ui/patients/patients.dart' as _i589;
import '../ui/personal/duty_roster.dart' as _i866;
import '../ui/personal/roster_table.dart' as _i645;
import '../ui/personal/upcoming_duties.dart' as _i125;
import '../ui/personal/user.dart' as _i648;
import '../ui/search.dart' as _i317;
import '../ui/settings.dart' as _i68;
import 'dependencies.dart' as _i372;

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
    gh.factory<_i214.ApplicationBloc>(() => _i214.ApplicationBloc());
    gh.factory<_i1027.NewQuickPatientBloc>(() => _i1027.NewQuickPatientBloc());
    gh.factory<_i9.AppDrawerBloc>(() => _i9.AppDrawerBloc());
    gh.factory<_i148.AuthenticationBloc>(() => _i148.AuthenticationBloc());
    gh.factory<_i53.HomeBloc>(() => _i53.HomeBloc());
    gh.factory<_i423.ImageriesBloc>(() => _i423.ImageriesBloc());
    gh.factory<_i404.InvestigationsBloc>(() => _i404.InvestigationsBloc());
    gh.factory<_i866.DutyRosterBloc>(() => _i866.DutyRosterBloc());
    gh.factory<_i645.RosterTableBloc>(() => _i645.RosterTableBloc());
    gh.factory<_i125.UpcomingDutiesBloc>(() => _i125.UpcomingDutiesBloc());
    gh.factory<_i68.SettingsBloc>(() => _i68.SettingsBloc());
    await gh.factoryAsync<_i655.PackageInfo>(
      () => dependencies.appInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i179.Store>(
      () => dependencies.store,
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<dynamic>>(
      () => dependencies.hive,
      preResolve: true,
    );
    gh.factory<_i243.AppointmentsBloc>(() => _i243.AppointmentsBloc());
    gh.factory<_i389.MedicationsBloc>(() => _i389.MedicationsBloc());
    gh.factory<_i566.NewPatientBloc>(() => _i566.NewPatientBloc());
    gh.factory<_i192.PatientBloc>(() => _i192.PatientBloc());
    gh.factory<_i589.PatientsBloc>(() => _i589.PatientsBloc());
    gh.factory<_i257.PatientTypesBloc>(() => _i257.PatientTypesBloc());
    gh.factory<_i648.UserBloc>(() => _i648.UserBloc());
    gh.factory<_i317.SearchBloc>(() => _i317.SearchBloc());
    gh.singleton<_i315.AuthenticationRepository>(
        () => _i315.AuthenticationRepository());
    gh.singleton<_i74.DutiesRepository>(() => _i74.DutiesRepository());
    gh.singleton<_i744.HospitalRepository>(() => _i744.HospitalRepository());
    gh.singleton<_i324.ImageriesRepository>(() => _i324.ImageriesRepository());
    gh.singleton<_i314.InvestigationsRepository>(
        () => _i314.InvestigationsRepository());
    gh.singleton<_i293.Navigation>(() => _i293.Navigation());
    gh.singleton<_i729.PatientTypesRepository>(
        () => _i729.PatientTypesRepository());
    gh.singleton<_i729.PatientsRepository>(() => _i729.PatientsRepository());
    gh.singleton<_i604.PicturesRepository>(() => _i604.PicturesRepository());
    gh.singleton<_i239.SettingsRepository>(() => _i239.SettingsRepository());
    gh.singleton<_i139.UpcomingDutyFinder>(() => _i139.UpcomingDutyFinder());
    gh.singleton<_i408.UserRepository>(() => _i408.UserRepository());
    return this;
  }
}

class _$Dependencies extends _i372.Dependencies {}
