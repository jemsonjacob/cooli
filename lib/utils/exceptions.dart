/// The exceptions types
enum EnumLocationExceptions {
  serviceNotEnabled,
  permissionDenied,
  permissionDeniedForever,
  // When the position is null
  locationNull,
}

/// The exception to handle the locations
class LocationException implements Exception {
  final EnumLocationExceptions enumType;
  final String? msg;

  const LocationException({required this.enumType, this.msg}) : super();

  @override
  String toString() => "$enumType:$msg";
}

/// The enum for API exceptions
enum EnumAPIExceptions {
  // On the api result returns blank or empty
  apiResultEmpty,
  // When the data field is empty
  dataFieldEmpty,
  // When the [success] field in data is false
  dataSuccessFalse,
  // When http status error
  httpStatusError,
  // Invalid Token
  invalidToken,
  // Token api returns empty
  emptyTokenFromServer,
  // The result type is invalid or mismatch
  invalidResultType,
}

/// The api exceptions handles the api calls and responses
class APIException implements Exception {
  final EnumAPIExceptions enumProperty;
  final String message;
  List? otherData;
  dynamic data;
  bool? asToast = false;

  /// The default constructor of the exception
  /// The exception can be thrown if any error occured in api calls or results
  ///
  /// [enumProperty] represent the type of error from [EnumAPIExceptions]
  /// [message] is a string message
  /// [otherData] can be any type [T], incase if need to pass any data from
  /// error
  APIException({
    required this.enumProperty,
    required this.message,
    this.otherData,
    this.data,
    this.asToast,
  }) : super();

  @override
  String toString() => "$enumProperty:$message:$otherData";

  String? toStringOtherData() => otherData?.join(",");
}

enum EnumLoginExceptions {
  newUser,
}

class AppLoginException implements Exception {
  final EnumLoginExceptions type;
  String? message;

  AppLoginException({required this.type, this.message}) : super();

  @override
  String toString() => message ?? "Type: $type";
}
