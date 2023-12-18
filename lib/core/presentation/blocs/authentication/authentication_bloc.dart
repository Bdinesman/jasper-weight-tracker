import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:weight_tracker/core/domain/entities/authentication_method.dart';
import 'package:weight_tracker/core/domain/entities/user.dart';
import 'package:weight_tracker/core/domain/exceptions/authentication_exceptions.dart';
import 'package:weight_tracker/core/domain/repositories/authentication_repository.dart';
import 'package:weight_tracker/features/view_weights/domain/repositories/weights_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationInitial()) {
    on<AuthenticationSignInUserSubmitted>(
      _onAuthenticateUserSubmitted,
    );
    on<AuthenticationSignOutUserSubmitted>(
      _onUnauthenticateUserSubmitted,
    );
  }
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onAuthenticateUserSubmitted(
    AuthenticationSignInUserSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (state is AuthenticationUserSignInSuccess) {
      return;
    }
    emit(
      const AuthenticationUserSignInInProgress(),
    );
    try {
      //In a production appliation, this would allow
      //the application to undergo different authentication. But for this assignment,
      //only annonymous authentication is being used
      var authenticationMethod = event.authenticationMethod;

      ///Switch statment provides type checking and ensures robostuness
      var _ = switch (authenticationMethod) {
        AnnonymousAuthentication() => await _annonymousAuthentication(),
        _ => await _annonymousAuthentication(),
      };

      var user = _authenticationRepository.user;
      if (user == null) throw NoUserFoundException();
      GetIt.I.registerLazySingleton(
        () => WeightsRepository(
          userId: user.uid,
          weightsService: GetIt.I.get(),
        ),
      );
      return emit(
        AuthenticationUserSignInSuccess(user: user),
      );
    } catch (error) {
      return emit(AuthenticationUserSignInError(error: error));
    }
  }

  Future<void> _onUnauthenticateUserSubmitted(
    AuthenticationSignOutUserSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    var startingState = state;
    //User is already logged out
    if (startingState is! AuthenticationUserSignInSuccess) return;
    var user = startingState.user;

    try {
      await _authenticationRepository.signOut();
    } finally {
      if (GetIt.I.isRegistered<WeightsRepository>()) {
        GetIt.I.unregister<WeightsRepository>();
      }
      //Sign out the user, even if there is an error
      emit(AuthenticationUserSignOutSuccess(user: user));
    }
  }

  Future<void> _annonymousAuthentication() async {
    try {
      await _authenticationRepository.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  //Publically exposed methods
  Future<void> signIn(AuthenticationMethod authenticationMethod) async {
    add(
      AuthenticationSignInUserSubmitted(
        authenticationMethod: authenticationMethod,
      ),
    );

    await stream.takeWhile((state) => false).last;
  }

  void signOut() => add(
        const AuthenticationSignOutUserSubmitted(),
      );
}
