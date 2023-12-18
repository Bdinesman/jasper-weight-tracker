part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {
  const AuthenticationState();
}

mixin AuthenticationError on AuthenticationState {
  Object get error;
}

final class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
  //Treat all instances of AuthenticationInitial as identical
  @override
  bool operator ==(Object other) => other is AuthenticationInitial;

  @override
  int get hashCode => Object.hashAll([]);
}

/*
Sign In States
*/
final class AuthenticationUserSignInInProgress extends AuthenticationState {
  const AuthenticationUserSignInInProgress();
}

final class AuthenticationUserSignInSuccess extends AuthenticationState {
  const AuthenticationUserSignInSuccess({required this.user});
  final User user;
  @override
  bool operator ==(Object other) =>
      other is AuthenticationUserSignInSuccess && other.user == user;

  @override
  int get hashCode => Object.hashAll([user]);
}

final class AuthenticationUserSignInError extends AuthenticationState
    with AuthenticationError {
  AuthenticationUserSignInError({required this.error});
  @override
  final Object error;
  @override
  bool operator ==(Object other) =>
      other is AuthenticationUserSignInError && other.error == error;

  @override
  int get hashCode => Object.hashAll([error]);
}

/*
Sign Out States
*/
final class AuthenticationUserSignOutInProgress
    extends AuthenticationUserSignInSuccess {
  const AuthenticationUserSignOutInProgress({required super.user});
  @override
  bool operator ==(Object other) =>
      other is AuthenticationUserSignOutInProgress && other.user == user;

  @override
  int get hashCode => Object.hashAll([user]);
}

final class AuthenticationUserSignOutSuccess extends AuthenticationState {
  const AuthenticationUserSignOutSuccess({required this.user});
  final User user;
  @override
  bool operator ==(Object other) =>
      other is AuthenticationUserSignOutSuccess && other.user == user;

  @override
  int get hashCode => Object.hashAll([user]);
}
