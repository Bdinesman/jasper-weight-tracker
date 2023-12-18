import 'package:weight_tracker/core/domain/entities/user.dart';
import 'package:weight_tracker/core/domain/services/authentication/authentication_service.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;
  final AuthenticationService _authenticationService;

  User? _authenticatedUser;
  User? get user => _authenticatedUser;

  Future<void> signInAnonymously() async {
    try {
      //User is already signed In
      if (_authenticatedUser != null) return;
      var currentFirebaseUser = _authenticationService.currentFirebaseUser;
      if (currentFirebaseUser != null) {
        _authenticatedUser = User.fromFirebaseUser(currentFirebaseUser);
      }
      _authenticatedUser ??= await _authenticationService.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _authenticationService.signOut();
    } finally {
      _authenticatedUser = null;
    }
  }
}
