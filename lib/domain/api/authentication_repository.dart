import 'package:injectable/injectable.dart';
import 'package:patients/domain/models/authentication.dart';
import 'package:patients/utils/architecture.dart';

@singleton
class AuthenticationRepository extends Repository {
  final Resource<Authentication> _auth = Resource<Authentication>();

  // Current authentication state
  Resource<Authentication> get auth => _auth;
  bool get isAuthenticated => _auth.hasData && _auth.data!.authenticated;
  Authentication? get currentUser => _auth.data;
  void init() {
    // Check for saved authentication on startup
    _checkSavedAuth();
  }

  Future<bool> login(String email, String password) async {
    if (email == 'adn@gmail.com' && password == '1234') {
      Authentication()
        ..id = 1
        ..name = 'Adn'
        ..email = email
        ..userType = UserType.doctor;
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    _auth.setData(Authentication()); // Reset to empty auth
    notifyListeners();
  }

  void _checkSavedAuth() {
    // TO DO: Check SharedPreferences for saved auth
    // For now, start with empty state
    _auth.setData(Authentication());
  }
}
