

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class AuthRepository {
  Future<void> login({required String email, required String password});
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {
    // Stimulate API call
    await Future<void>.delayed(const Duration(seconds: 2));

    if (email.trim().toLowerCase() == 'finnvu@yopmail.com' && password.trim() == '123456') return;

    throw const AuthException(
      'Incorrect email or password. Please try again.',
    );
  }
  
}
