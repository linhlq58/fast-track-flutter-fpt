class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Simulate a network request.
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'demo@example.com' &&
        password == 'password123') {
      return;
    }

    throw const AuthException('Invalid email or password.');
  }

  Future<void> logout() async {
    // A real implementation would clear the session/token.
    await Future<void>.value();
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}