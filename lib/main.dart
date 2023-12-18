import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/core/domain/repositories/authentication_repository.dart';
import 'package:weight_tracker/core/domain/services/authentication/authentication_service.dart';
import 'package:weight_tracker/core/domain/services/authentication/firebase_auth_service.dart';
import 'package:weight_tracker/core/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:weight_tracker/core/presentation/widgets/weight_tracker.dart';
import 'package:weight_tracker/features/view_weights/data/services/weights_api_service.dart';
import 'package:weight_tracker/features/view_weights/data/services/weights_service.dart';
import 'package:weight_tracker/firebase_options.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  registerIndependentServices();
  registerDependentServices();
  registerDependentBlocs();
  runApp(const WeightTracker());
}

void registerIndependentServices() {
  var getIt = GetIt.I;
  getIt
    ..registerLazySingleton(
      () => FirebaseAuthService(),
    )
    ..registerLazySingleton(
      () => WeightsApiService(),
    );
}

void registerDependentServices() {
  var getIt = GetIt.I;
  getIt
    ..registerLazySingleton(
      () => AuthenticationService(firebaseAuthService: getIt.get()),
    )
    ..registerLazySingleton(
      () => WeightsService(weightsApiService: getIt.get()),
    );
}

void registerDependentBlocs() {
  var getIt = GetIt.I;
  getIt

      //Prevent exposing the AuthRepository for safety reasons
      .registerLazySingleton(
    () => AuthenticationBloc(
      authenticationRepository: AuthenticationRepository(
        authenticationService: getIt.get(),
      ),
    ),
  );
}
