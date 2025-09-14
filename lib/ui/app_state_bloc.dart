import 'package:patients/domain/api/authentication_repository.dart';
import 'package:patients/utils/architecture.dart';

/// App State Bloc - manages global app state and navigation
class AppStateBloc extends Bloc {
  late final AuthenticationRepository authRepo;
  
  @override
  void initState() {
    authRepo = watch<AuthenticationRepository>();
  }
  
  bool get isAuthenticated => authRepo.isAuthenticated;
  bool get isLoading => authRepo.auth.isLoading;
  
  Future<void> logout() async {
    await authRepo.logout();
  }
}