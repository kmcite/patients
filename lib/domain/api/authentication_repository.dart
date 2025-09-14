import 'package:patients/domain/models/authentication.dart';
import 'package:patients/utils/architecture.dart';

class AuthenticationRepository extends Repository {
  final Resource<Authentication> _auth = Resource<Authentication>();

  // Current authentication state
  Resource<Authentication> get auth => _auth;
  bool get isAuthenticated => _auth.hasData && _auth.data!.authenticated;
  Authentication? get currentUser => _auth.data;

  @override
  void init() {
    // Check for saved authentication on startup
    _checkSavedAuth();
  }

  Future<void> login(String email, String password) async {
    await _auth.execute(() async {
      // Simulate API call
      // await Future.delayed(const Duration(seconds: 1));

      // Simple validation (replace with real API)
      if (email == 'adn@gmail.com' && password == '1234') {
        return Authentication()
          ..id = 1
          ..name = 'Adn'
          ..email = email
          ..userType = UserType.doctor;
      } else {
        throw Exception('Invalid credentials');
      }
    });
    notifyListeners();
  }

  Future<void> logout() async {
    _auth.setData(Authentication()); // Reset to empty auth
    notifyListeners();
  }

  void _checkSavedAuth() {
    // TODO: Check SharedPreferences for saved auth
    // For now, start with empty state
    _auth.setData(Authentication());
  }
}
