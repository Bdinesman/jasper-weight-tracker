import 'package:firebase_auth/firebase_auth.dart';

//Breaking this out into a seperate service rathr than using [FriebaseAuth] directly
//allows for easier unit testing and updates in the event of breaking changes with Firebase
class FirebaseAuthService {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  Future<UserCredential> signInAnonymously() {
    try {
      return FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() {
    try {
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
