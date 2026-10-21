import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(const AuthState(status: AuthStatus.success));
    } on AuthException catch (error) {
      emit(AuthState(
        status: AuthStatus.failure,
        errorMessage: error.message,
      ));
    } catch (_) {
      emit(const AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState(status: AuthStatus.initial));
  }
}
