import 'package:cooli/config/app_config.dart';
import 'package:cooli/utils/connection_failed_screen.dart';
import 'package:cooli/utils/extensions.dart';
import 'package:flutter/widgets.dart';

import '/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/utils/sp_keys.dart' as sp_keys;

mixin WebAPIMixin {
  /// Returns the token from Shared Preference
  /// Token is saved as key pair of [keyToken]
  /// Throws exception in case of any error
  Future<String?> getTokenFromSharedPref() => SharedPreferences.getInstance()
      .then<String?>((sp) => sp.getString(sp_keys.keyToken));

  /// Returns opted language code from Shared Preference
  /// Token is saved as key pair of [keyLanguageCode]
  /// Throws exception in case of any error
  Future<String?> getLanguageSharedPref() {
    return SharedPreferences.getInstance().then<String?>(
      (sp) => sp.getString(sp_keys.keyLanguageCode),
    );
  }

  /// Returns opted Tenant code from Shared Preference
  /// Token is saved as key pair of [keyTenantCode]
  /// Throws exception in case of any error
  Future<String?> getTenantCodeSharedPref() {
    return SharedPreferences.getInstance().then<String?>(
      (sp) => sp.getString(sp_keys.keyTenantCode),
    );
  }

  /// Handle the dio error in call
  void onDioError(DioException error, String apiName,
      { Function? apiFunction}) {
    String? msg;
    switch (error.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.unknown:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        msg = "Please check your internet connection and try again";
        if (!Navigator.of(AppConfig.navKey.currentState!.context)
            .isCurrentRoute(ConnectionFailedScreen.routeName)) {
          Navigator.pushNamed(
            AppConfig.navKey.currentState!.context,
            ConnectionFailedScreen.routeName,
            arguments: ConnectionFailedScreenParams(
              failedAPI: apiFunction,
              autoRetry: true,
            ),
          );
        }
        break;
      case DioExceptionType.badResponse:

        /// Check the api response has data
        if (error.response?.data == null) {
          throw APIException(
              enumProperty: EnumAPIExceptions.httpStatusError,
              message: msg ?? "$apiName:${error.message}",
              otherData: [error.error]);
        }

        if (error.response!.data is Map) {
          final Map data = error.response!.data;
          if (data.containsKey('Message')) {
            if (data['Message'] == 'Unauthenticated') {
              throw APIException(
                  enumProperty: EnumAPIExceptions.dataSuccessFalse,
                  message: 'Token expired');
            }

            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['Message'],
              data: error.response,
            );
          }

          if (data.containsKey('StatusDesc')) {
            if ([
              "invalid session",
              "invalid session.",
              "not a valid session",
              "not a valid session.",
            ].contains(data["StatusDesc"]?.toString().toLowerCase())) {
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: data['StatusDesc'],
                data: error.response,
              );
            }
          }

          if (data.containsKey('message')) {
            if (data['message'] == 'Unauthenticated') {
              throw APIException(
                enumProperty: EnumAPIExceptions.invalidToken,
                message: 'Token expired',
                data: error.response,
              );
            }

            throw APIException(
              enumProperty: EnumAPIExceptions.dataSuccessFalse,
              message: data['message'],
              data: error.response,
            );
          }
        }

        break;
      case DioExceptionType.cancel:
        msg = "The request has been cancelled.";
        break;

      case DioExceptionType.badCertificate:
        break;
    }
    throw APIException(
        enumProperty: EnumAPIExceptions.httpStatusError,
        message: msg ?? "$apiName:${error.message}",
        otherData: [error.response?.data]);
  }

  Future<Map> validateResStatusData(Response<dynamic> response) async {
    if (response.data == null) {
      throw APIException(
          enumProperty: EnumAPIExceptions.apiResultEmpty,
          message: "The response is empty from server");
    }

    if (response.data is! Map) {
      throw APIException(
          enumProperty: EnumAPIExceptions.invalidResultType,
          message: "Invalid result type from API response");
    }

    final Map data = response.data;

    if (data.containsKey("status")) {
      if (data["status"]?.toString() == "500") {
        String? msg = "API response error from server";
        if (data.containsKey("message") &&
            (data["message"]?.toString().isNotEmpty ?? false)) {
          msg = data["message"];
        }
        throw APIException(
            enumProperty: EnumAPIExceptions.dataSuccessFalse,
            message: msg ?? '');
      }

      if (data["status"]?.toString() == "422") {
        String? msg = "Validation Error";
        if (data.containsKey("message") &&
            (data["message"]?.toString().isNotEmpty ?? false)) {
          msg = data["message"];
        }
        throw APIException(
            enumProperty: EnumAPIExceptions.dataSuccessFalse,
            message: msg ?? '');
      }
    }

    //Navigating back from Connection failed screen if showing on 
    if (Navigator.of(AppConfig.navKey.currentState!.context)
        .isCurrentRoute(ConnectionFailedScreen.routeName)) {
      Navigator.pop(AppConfig.navKey.currentState!.context);
    }

    return data;
  }
}
