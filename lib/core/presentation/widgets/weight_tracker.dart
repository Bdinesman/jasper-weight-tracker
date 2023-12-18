import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_tracker/core/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:weight_tracker/features/sign_in/presentation/sign_in_page.dart';
import 'package:weight_tracker/features/view_weights/presentation/weights_page.dart';

final _goRouter = GoRouter(
  routes: [
    //Wrapper that automatically signs out user
    ShellRoute(
      builder: (context, state, child) => BlocListener(
        bloc: GetIt.I.get<AuthenticationBloc>(),
        listener: (context, state) {
          if (state is AuthenticationUserSignOutSuccess) {
            context.goNamed('signIn');
          } else if (state is AuthenticationUserSignInSuccess) {
            context.goNamed('viewWeights');
          }
        },
        child: child,
      ),
      routes: [
        GoRoute(
          path: '/signIn',
          name: 'signIn',
          builder: (context, state) => SignInPage(),
        ),
        GoRoute(
          path: '/weights',
          name: 'viewWeights',
          builder: (context, state) => ViewWeightsPage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    var isAuthenticated = GetIt.I.get<AuthenticationBloc>().state
        is AuthenticationUserSignInSuccess;
    if (!isAuthenticated && state.name != 'signIn') {
      return state.namedLocation('signIn');
    }
    return null;
  },
);

class WeightTracker extends StatefulWidget {
  const WeightTracker({super.key});

  @override
  State<WeightTracker> createState() => _WeightTrackerState();
}

class _WeightTrackerState extends State<WeightTracker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _goRouter,
    );
  }
}
