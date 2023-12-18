import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:weight_tracker/core/domain/entities/user.dart';
import 'package:weight_tracker/core/domain/exceptions/authentication_exceptions.dart';
import 'package:weight_tracker/core/domain/services/authentication/firebase_auth_service.dart';

class AuthenticationService {
  const AuthenticationService({
    required FirebaseAuthService firebaseAuthService,
  }) : _firebaseAuthService = firebaseAuthService;
  final FirebaseAuthService _firebaseAuthService;
  firebase.User? get currentFirebaseUser => _firebaseAuthService.currentUser;
  Future<User> signInAnonymously() async {
    try {
      var user = (await _firebaseAuthService.signInAnonymously()).user;
      if (user == null) throw NoUserFoundException();
      return User.fromFirebaseUser(user);
    } on firebase.FirebaseAuthException {
      throw AuthenticationException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() {
    try {
      return _firebaseAuthService.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
