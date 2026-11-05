import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable {
  const AppFailure(this.message);

  final String message;

  bool get isRecoverable => false;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure()
      : super('No internet connection. Check your connection and try again.');

  @override
  bool get isRecoverable => true;
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure()
      : super('The request timed out. Please try again.');

  @override
  bool get isRecoverable => true;
}

class ServerFailure extends AppFailure {
  const ServerFailure(this.statusCode)
      : super('Something went wrong on the server. Please try again.');

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  @override
  bool get isRecoverable => statusCode == 503 || statusCode == 500;
}

class ClientFailure extends AppFailure {
  const ClientFailure(this.statusCode)
      : super('The request could not be completed.');

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure()
      : super('Your session has expired. Please sign in again.');
}

class ParseFailure extends AppFailure {
  const ParseFailure()
      : super('The server returned data in an unexpected format.');
}

class UnknownFailure extends AppFailure {
  const UnknownFailure()
      : super('Something went wrong. Please try again.');
}