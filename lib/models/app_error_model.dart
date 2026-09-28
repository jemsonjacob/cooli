/// Standard error payload used across providers/services.
class AppError<T> {
  /// Human readable error message to show in UI/logs.
  final String message;

  /// Raw response payload (if any) that caused the error.
  final T? response;

  const AppError({
    required this.message,
    this.response,
  });

  @override
  String toString() => message;
}
