/// Base class for all application exceptions.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}

/// Network/connection failure exception.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Unable to connect to the server. Please check your network connection.']);
}

/// Request timed out exception.
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'The request timed out. Please try again later.']);
}

/// Server returned 4xx or 5xx HTTP response exception.
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode, super.details});
}

/// 404 Not Found exception.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.'])
      : super(statusCode: 404);
}

/// 400 Bad Request / Validation exception.
class ValidationException extends AppException {
  const ValidationException(super.message, {super.details})
      : super(statusCode: 400);
}

/// 401/403 Unauthorized or Forbidden exception.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'You are not authorized to perform this action.'])
      : super(statusCode: 401);
}

/// JSON parsing or serialization exception.
class SerializationException extends AppException {
  const SerializationException([super.message = 'Failed to process data from server.']);
}
