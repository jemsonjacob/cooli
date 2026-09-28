import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionFailedScreenParams {
  ///The function in which the failed API is called
  final Function? failedAPI;

  ///If want to perform anything while trying to recall
  final VoidCallback? onRetry;

  ///Should retry automatically on [autoRetryInterval]?
  final bool autoRetry;

  ConnectionFailedScreenParams({
    this.failedAPI,
    this.onRetry,
    this.autoRetry = false,
  });
}

class ConnectionFailedScreen extends StatefulWidget {
  static const String routeName = '/ConnectionFailedScreen';
  final ConnectionFailedScreenParams param;
  const ConnectionFailedScreen({super.key, required this.param});

  @override
  State<ConnectionFailedScreen> createState() => _ConnectionFailedScreenState();
}

class _ConnectionFailedScreenState extends State<ConnectionFailedScreen> {
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker.instance.onStatusChange.listen(
      (event) async {
        if (event == InternetConnectionStatus.connected) {
          if (widget.param.autoRetry) {
            if (widget.param.onRetry != null) {
              widget.param.onRetry!();
            }
            await (widget.param.failedAPI ?? () {})() as Future;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    InternetConnectionChecker.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (context, isLoading, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    //Replace below Placeholder with appropriate graphics
                    const Placeholder(),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          loadingNotifier.value = true;
                          if (await InternetConnectionChecker
                              .instance.hasConnection) {
                            if (widget.param.onRetry != null) {
                              widget.param.onRetry!();
                            }
                            await (widget.param.failedAPI ?? () {})() as Future;
                          } else {
                            //delay to show loading indicator on retry if there is no connection
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                          }
                          loadingNotifier.value = false;
                        } on Exception catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text('Try again'),
                    )
                  ],
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            );
          }),
    );
  }
}
