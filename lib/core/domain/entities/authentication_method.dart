import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthenticationMethod {
  const AuthenticationMethod();
}

///User is signing in anonymously, usually using [FirebaseAuth]
final class AnnonymousAuthentication extends AuthenticationMethod {}

///User is attempting to sign in using email and password
final class EmailAndPasswordAuthentication extends AuthenticationMethod {}

///User is attempting to sign in using [AuthCredential]s
final class FirebaseCredentialAuthentication extends AuthenticationMethod {
  const FirebaseCredentialAuthentication({required this.credential});
  final AuthCredential credential;
}
