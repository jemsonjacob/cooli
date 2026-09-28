import 'dart:convert';

import 'package:cooli/utils/app_build_methods.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LoggerStackTrace {
  const LoggerStackTrace._({
    required this.functionName,
    required this.callerFunctionName,
    required this.fileName,
    required this.lineNumber,
    required this.columnNumber,
  });

  factory LoggerStackTrace.from(StackTrace trace) {
    final frames = trace.toString().split('\n');
    final functionName = _getFunctionNameFromFrame(frames[0]);
    final callerFunctionName = _getFunctionNameFromFrame(frames[1]);
    final fileInfo = _getFileInfoFromFrame(frames[0]);

    return LoggerStackTrace._(
      functionName: functionName,
      callerFunctionName: callerFunctionName,
      fileName: fileInfo[0],
      lineNumber: int.parse(fileInfo[1]),
      columnNumber: int.parse(fileInfo[2].replaceFirst(')', '')),
    );
  }

  final String functionName;
  final String callerFunctionName;
  final String fileName;
  final int lineNumber;
  final int columnNumber;

  static List<String> _getFileInfoFromFrame(String trace) {
    final indexOfFileName = trace.indexOf(RegExp('[A-Za-z]+.dart'));
    final fileInfo = trace.substring(indexOfFileName);

    return fileInfo.split(':');
  }

  static String _getFunctionNameFromFrame(String trace) {
    final indexOfWhiteSpace = trace.indexOf(' ');
    final subStr = trace.substring(indexOfWhiteSpace);
    final indexOfFunction = subStr.indexOf(RegExp('[A-Za-z0-9]'));

    return subStr
        .substring(indexOfFunction)
        .substring(0, subStr.substring(indexOfFunction).indexOf(' '));
  }

  @override
  String toString() {
    return '('
        'functionName: $functionName, '
        'callerFunctionName: $callerFunctionName, '
        'fileName: $fileName, \t'
        'lineNumber: $lineNumber, \t'
        'columnNumber: $columnNumber)\n';
  }
}

class AppStackInterceptor extends Interceptor {
  final ValueChanged<String>? onDisplayLog;

  AppStackInterceptor({this.onDisplayLog}) : super();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      _displayLog("\n\n\n*********** REQUEST ************\n");
      _displayRequestOption(options);
    } on Exception {
      debugPrint("Error");
    }
    handler.next(options);
  }

  void _displayRequestOption(RequestOptions options) {
    _displayLog("URL: ${options.method} ${options.uri.toString()}");
    _displayLog("\n");
    _displayLog("\n");

    _displayLog("HEADERS: ${jsonEncode(options.headers)}");
    _displayLog("\n");

    if (options.data != null) {
      if (options.data is FormData) {
      } else if (options.data is Map) {
        _displayLog("DATA: ${jsonEncode(options.data as Map)}");
      } else {
        _displayLog("DATA: ${options.data}");
      }
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      _displayLog("\n\n\n************ RESPONSE ***********\n");

      _displayResponse(response);
    } on Exception {
      debugPrint("Error");
    }
    handler.next(response);
  }

  void _displayResponse(Response<dynamic> response) {
    _displayLog(
        "URL: ${response.requestOptions.method} ${response.realUri.toString()}");
    _displayLog("\n");
    _displayLog("\n");
    _displayLog("RESPONSE: ${response.data.toString()}");
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      _displayLog("\n\n\n************ ERROR ***********\n");
      _displayRequestOption(err.requestOptions);
      _displayLog('\n');
      _displayLog(err.message ?? "");
      _displayLog('\n');

      if (err.response != null) {
        _displayResponse(err.response!);
      }
    } on Exception {
      debugPrint("Error");
    }
    handler.next(err);
  }

  void _displayLog(String val) {
    if (onDisplayLog != null) {
      onDisplayLog!(val);
    }
  }
}

class AppStackInterceptorBuilder extends StatefulWidget {
  static final ValueNotifier<String> _logNotfier = ValueNotifier("");

  static set log(String value) {
    _logNotfier.value += "\n$value";
  }

  static AppStackInterceptor appStackInterceptor = AppStackInterceptor(
    onDisplayLog: _addToNotifier,
  );

  final Widget child;

  const AppStackInterceptorBuilder({super.key, required this.child});
  @override
  State<AppStackInterceptorBuilder> createState() =>
      _AppStackInterceptorBuilderState();

  static void _addToNotifier(String value) {
    _logNotfier.value += value;
  }
}

class _AppStackInterceptorBuilderState
    extends State<AppStackInterceptorBuilder> {
  final _scrollController = ScrollController();

  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier(false);

  bool isExpanded = false;

  Offset _offSet = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;
    final double maxWidth =
        MediaQuery.of(context).size.width - safeAreaPadding.horizontal;
    final double maxHeight =
        MediaQuery.of(context).size.height - safeAreaPadding.vertical;
    return Material(
      child: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            double newOffsetX = _offSet.dx + details.delta.dx;
            double newOffsetY = _offSet.dy + details.delta.dy;
            setState(() {
              _offSet = Offset(
                newOffsetX.clamp(0, maxWidth),
                newOffsetY.clamp(0, maxHeight),
              );
            });
          },
          child: Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: ValueListenableBuilder<bool>(
                    valueListenable: _isExpandedNotifier,
                    builder: (context, isExpanded, _) {
                      this.isExpanded = isExpanded;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isExpanded)
                            Expanded(
                              child: SafeArea(
                                left: false,
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.8) ,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  AppStackInterceptorBuilder
                                                      ._logNotfier.value = "",
                                              style: TextButton.styleFrom(
                                                // primary: Colors.green,
                                                textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              child: const Text("Clear All"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text:
                                                            AppStackInterceptorBuilder
                                                                ._logNotfier
                                                                .value));
                                                showToast("copied");
                                              },
                                              style: TextButton.styleFrom(
                                                // primary: Colors.green,
                                                textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              child: const Text("Copy"),
                                            ),
                                            // TextButton(
                                            //   onPressed: () async {
                                            //     await _forceLogout(context);
                                            //   },
                                            //   style: TextButton.styleFrom(
                                            //     // primary: Colors.green,
                                            //     textStyle: const TextStyle(
                                            //       fontSize: 12,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            //   child: const Text("Force Logout"),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          controller: _scrollController,
                                          child: ValueListenableBuilder<String>(
                                            valueListenable:
                                                AppStackInterceptorBuilder
                                                    ._logNotfier,
                                            builder: (context, log, _) =>
                                                Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: SelectableText(
                                                log,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
              ),
              Positioned(
                left: _offSet.dx,
                top: _offSet.dy,
                child: InkWell(
                  onTap: () => _onTapExpand(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    padding: const EdgeInsets.all(1),
                    child: AnimatedIcon(
                      color: Theme.of(context).iconTheme.color,
                      icon: AnimatedIcons.play_pause,
                      progress: AlwaysStoppedAnimation<double>(
                          isExpanded ? 1.0 : 0.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTapExpand() {
    _isExpandedNotifier.value = !_isExpandedNotifier.value;
    if (_isExpandedNotifier.value) {
      try {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 350),
              curve: Curves.ease),
        );
      } on Exception {
        debugPrint("Error");
      }
    }
  }

  // _forceLogout(BuildContext context) {
  //   SpHelper.clearAll();
  // }
}
