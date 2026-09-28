import 'dart:async';

import 'package:cooli/models/app_error_model.dart';
import 'package:cooli/providers/_mixins.dart';
import 'package:cooli/utils/extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '_mixins_api.dart';

class WebAPIService with WebAPIMixin, MixinAPIProvider {
  WebAPIService._initialise()
      : _dio = Dio(BaseOptions(
            // connectTimeout: 5000, receiveTimeout: 3000,
            headers: {
              "accept": "application/json",
            })) {
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseHeader: false,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
      // ..interceptors.add(AppStackInterceptorBuilder.appStackInterceptor);
    }
  }

  factory WebAPIService() => WebAPIService._initialise();

  final Dio _dio;

  Dio get dio => _dio;

  Future<bool> initTokenToHeader({bool initToken = true}) =>
      getTokenFromSharedPref().then((token) {
        if (token?.isEmpty ?? true) {
          return true;
        }
        if (_dio.options.headers.containsKey('Authorization')) {
          _dio.options.headers.remove('Authorization');
        }
        if (initToken) {
          _dio.options.headers
              .putIfAbsent('Authorization', () => 'Bearer $token');
          debugPrint('Authorization==>${token!}');
        }
        return true;
      });

  ///initialize language code in header
  Future<bool> initLangPrefToHeader() =>
      getLanguageSharedPref().then((languageCode) async {
        if (_dio.options.headers.containsKey('lang')) {
          _dio.options.headers.remove('lang');
        }
        _dio.options.headers.putIfAbsent('lang', () => languageCode ?? 'en');
        return true;
      });

  /// Initializes the tenant code in the header.
  ///
  /// This function retrieves the tenant code from shared preferences and sets it
  /// in the Dio headers. If the 'tenant' header already exists, it is removed
  /// before setting the new tenant code.
  ///
  /// Returns a [Future] that completes with `true` when the tenant code is successfully set.
  Future<bool> initTenantPrefToHeader() =>
      getTenantCodeSharedPref().then((tenantCode) async {
        if (_dio.options.headers.containsKey('tenant')) {
          _dio.options.headers.remove('tenant');
        }
        _dio.options.headers.putIfAbsent('tenant', () => tenantCode ?? '0');
        return true;
      });

  /// Executes an API call and handles its response.
  ///
  /// This function performs the following steps:
  /// 1. Calls the provided API method.
  /// 2. Validates the response status and data.
  /// 3. Converts the response data using the provided converter function.
  /// 4. Calls the [onSuccess] callback if the response is successful.
  /// 5. Handles any errors using the [onDioError] function and calls the [onError] callback if provided.
  ///
  /// The function also supports refreshing the API call using the [functionToRefresh] parameter.
  ///
  /// - [methodToCall]: The API method to call, which returns a [Future] of [Response].
  /// - [converter]: A function to convert the response data.
  /// - [onError]: An optional callback for handling errors.
  /// - [onSuccess]: An optional callback for handling successful responses.
  /// - [functionToRefresh]: An optional function to refresh the API call.
  ///
  /// Returns a [Future] that completes with the converted response data.
  Future<T> executeAPI<T>({
    required Future<Response<dynamic>> methodToCall,
    required FutureOr<T> Function(
      Map<dynamic, dynamic> value,
    ) converter,
    Function(AppError msg)? onError,
    Function(T value)? onSuccess,
    Function? functionToRefresh,
  }) {
    return methodToCall
        .then(validateResStatusData)
        .then(converter)
        .then((value) {
      onSuccess?.call(value);
      return value;
    }).catchError((ex) {
      onDioError(ex, 'setRegistrationVerifyOTP',
          apiFunction: functionToRefresh);
      throw ex;
    }, test: (ex) => ex is DioException).handleAPIException(
      handleAPIException: handleAPIException,
      onShowError: (msg) {
        onError?.call(msg);
      },
    );
  }
}
