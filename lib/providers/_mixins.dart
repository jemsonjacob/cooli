import 'dart:async';

import 'package:cooli/models/app_error_model.dart';

import '/utils/exceptions.dart';
import 'package:flutter/material.dart';

import '_base.dart';

typedef HandleAPIException = void Function({
  required APIException ex,
  required OnShowError onShowError,
  VoidCallback? onInvalidToken,
});

mixin MixinProgressProvider on BaseProvider {
  Completer<bool>? _completer;

  Completer<bool>? get progressCompleter => _completer;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();

    try {
      if (value) {
        _completer ??= Completer();
        if (_completer!.isCompleted) {
          _completer = Completer();
        }
      } else {
        if (_completer == null) return;

        if (!_completer!.isCompleted) {
          _completer?.complete(true);
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  void showLoading() => isLoading = true;
  void hideLoading() => isLoading = false;

  Future<T> callWithInProgress<T>({required Future<T> methodToCall}) async {
    try {
      showLoading();
      return await methodToCall;
    } catch (err) {
      rethrow;
    } finally {
      hideLoading();
    }
  }

  Future<void> callSmallDelay({int delayInMillis = 1500}) async {
    try {
      showLoading();
      await Future.delayed(Duration(milliseconds: delayInMillis));
    } finally {
      hideLoading();
    }
  }
}

/// The mixin provider for [BaseProvider], The api code will be
/// handled in this provider
///
mixin MixinAPIProvider {
  /// The method to handle the [APIException]
  ///
  /// [ex] The [APIException] to be passed
  /// [onShowError] will be invoked to display error
  /// [onInvalidToken] will be invoked if token is outdated or invalid
  ///
  void handleAPIException({
    required APIException ex,
    required OnShowError onShowError,
    VoidCallback? onInvalidToken,
  }) async {
    debugPrint(ex.toString());
    onInvalidToken ??= this.onInvalidToken;

    /// Hanlding the error cases
    switch (ex.enumProperty) {
      case EnumAPIExceptions.apiResultEmpty:
        onShowError(AppError(
            response: ex, message: "The data received from server is empty"));
        break;
      case EnumAPIExceptions.dataFieldEmpty:
        // onShowError("The data field from the server is empty");
        break;
      case EnumAPIExceptions.dataSuccessFalse:
        if ((ex.data != null)) {
          if (ex.data is Map) {
            final data = ex.data as Map;
            if (data.keys.contains("message") &&
                [
                  "invalid session",
                  "invalid session.",
                  "not a valid session",
                  "not a valid session.",
                  "invalid login details",
                ].contains(data["message"]?.toString().toLowerCase())) {
              onShowError(data["message"] ?? ex.message);
              onInvalidToken();
              break;
            }
          }
        }
        onShowError(AppError(
            message: ex.toStringOtherData() ?? ex.message, response: ex));

        break;
      case EnumAPIExceptions.httpStatusError:
        if (ex.otherData?.isNotEmpty ?? false) {
          final Map? res = ex.otherData?.firstWhere(
            (e) => e is Map,
            orElse: () => null,
          ) as Map?;
          if (res != null &&
              res.containsKey('message') &&
              res['message'] != null) {
            onShowError(res['message']);
            break;
          }
        }
        onShowError(
            AppError(message: "${ex.message} ${ex.data ?? ""}", response: ex));
        break;
      case EnumAPIExceptions.invalidToken:
        onInvalidToken();
        break;
      case EnumAPIExceptions.emptyTokenFromServer:
        onShowError(AppError(
            message:
                "Unable to recieve the token from server. Please try after sometime",
            response: ex));
        break;
      case EnumAPIExceptions.invalidResultType:
        onShowError(AppError(message: ex.message, response: ex));
        break;
    }
  }

  /// Handled the invalid token code
  void onInvalidToken() {
    // AppUserProvider().signOutUser();
    // AppConfig.navKey.currentState.pushNamedAndRemoveUntil(
    //   LoginScreen.route,
    //   (route) => false,
    // );
  }
}
