import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authRepository.login(
        email: event.email.trim(),
        password: event.password,
      );

      emit(const AuthSuccess());
    } on AuthException catch (error) {
      emit(AuthFailure(error.message));
    } catch (_) {
      emit(
        const AuthFailure(
          'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoggingOut());

    try {
      await _authRepository.logout();
    } finally {
      // This example always returns to the unauthenticated state.
      emit(const AuthInitial());
    }
  }
}