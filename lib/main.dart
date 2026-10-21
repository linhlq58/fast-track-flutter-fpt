import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_repository.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const LoginDemoApp());
}

class LoginDemoApp extends StatelessWidget {
  const LoginDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) => MockAuthRepository(),
      child: Builder(
        builder: (context) => BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          ),
          child: MaterialApp(
            title: 'Day 17 Login Flow',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            home: const AuthGate(),
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.success) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
