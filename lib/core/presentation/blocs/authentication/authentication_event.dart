part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationSignInUserSubmitted extends AuthenticationEvent {
  const AuthenticationSignInUserSubmitted({required this.authenticationMethod});
  final AuthenticationMethod authenticationMethod;
}

class AuthenticationSignOutUserSubmitted extends AuthenticationEvent {
  const AuthenticationSignOutUserSubmitted();
}
