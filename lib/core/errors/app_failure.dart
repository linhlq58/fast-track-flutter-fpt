sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure()
      : super('No internet connection. Check your connection and try again.');
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure()
      : super('The request timed out. Please try again.');
}

class ServerFailure extends AppFailure {
  const ServerFailure()
      : super('The server is temporarily unavailable. Please try again.');
}

class ClientFailure extends AppFailure {
  const ClientFailure()
      : super('The request could not be completed.');
}

class ParseFailure extends AppFailure {
  const ParseFailure()
      : super('The server returned data in an unexpected format.');
}

class UnknownFailure extends AppFailure {
  const UnknownFailure()
      : super('Something went wrong. Please try again.');
}
