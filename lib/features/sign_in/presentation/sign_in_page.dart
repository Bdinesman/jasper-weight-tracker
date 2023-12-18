import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weight_tracker/core/domain/entities/authentication_method.dart';
import 'package:weight_tracker/core/presentation/blocs/authentication/authentication_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Weight Tracker',
              style: textTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Center(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
              ),
              onPressed: () => GetIt.I
                  .get<AuthenticationBloc>()
                  .signIn(AnnonymousAuthentication()),
              child: const Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
