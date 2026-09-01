import '../errors/app_exception.dart';

/// Generic Result monad for clean error and success handling in repositories and view models.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Failure() => null,
      };

  AppException? get errorOrNull => switch (this) {
        Success() => null,
        Failure(error: final e) => e,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(error: final error) => failure(error),
    };
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}
