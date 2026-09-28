import 'dart:convert';
import 'dart:developer';

import 'package:cooli/models/app_error_model.dart';

import '/providers/_base.dart';
import '/providers/_mixins.dart';
import 'interceptors.dart';
import '/widgets/app_progress_widget.dart';
import '/widgets/list_scroll_more_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// The String extension class for the app
///
///
extension StringExtension on String {
  /// Append the svg location to the string
  String asAssetSvg() => 'assets/svgs/$this.svg';

  /// Append the image location to the string
  String asAssetImg() => 'assets/images/$this.png';

  /// Append the gif location to the string
  String asAssetGif() => 'assets/gifs/$this';

  ///
  ///capitalize first letter of every word
  String capitalizeAllWord() {
    var result = this[0].toUpperCase();
    for (int i = 1; i < length; i++) {
      if (this[i - 1] == " ") {
        result = result + this[i].toUpperCase();
      } else {
        result = result + this[i].toLowerCase();
      }
    }
    return result;
  }

  String replaceCharAt(int index, String newChar) {
    return substring(0, index) + newChar + substring(index + 1);
  }

  String replaceForEllipses() {
    // for (var word in this.split(' ')) {
    //   if (!checkArabic(word)) {
    //     this.replaceAll(word, word.replaceAll("", "\u{200B}"));
    //   }
    // }
    if (!checkArabic(this)) {
      return replaceAll('', "\u{200B}");
    }
    return this;
  }

  double? toDouble() {
    try {
      if (isEmpty) {
        return null;
      }
      return double.parse(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  bool isImageExtenstion(
      {List<String> imgExt = const <String>['png', 'jpg', 'jpeg', 'gif']}) {
    if (!contains('.')) return false;

    final ext = substring(lastIndexOf('.') + 1).toString();
    return imgExt.contains(ext);
  }
}

bool checkArabic(String text) {
  final regexExp = RegExp("[\u0621-\u064A]+");
  return regexExp.hasMatch(text);
}

/// The extension for the [Future]
extension FutureExtension<T> on Future<T> {
  /// Handle the loading states
  ///
  Future<T> coverWithProgress<I extends MixinProgressProvider>(I provider) =>
      Future(() {
        provider.isLoading = true;
      }).then<T>((_) => this).whenComplete(() => provider.isLoading = false);

  /// Handles the error
  Future<T> handleAPIException({
    required HandleAPIException handleAPIException,
    required OnShowError onShowError,
    VoidCallback? onInvalidToken,
  }) {
    return catchError(
      (ex) {
        handleAPIException(
          ex: ex,
          onShowError: onShowError,
          onInvalidToken: onInvalidToken,
        );
        throw ex;
      },
    );
  }

  /// enables isloading before exicuting future and disables after exicution.
  Future<T> setProgress<I extends MixinProgressProvider>(I provider) async {
    try {
      provider.showLoading();
      await this;
    } finally {
      provider.hideLoading();
    }
    return this;
  }

  /// Handles the error
  Future<T> handleAssertionException({required OnShowError onShowError}) {
    return catchError((ex) {
      if (ex is AssertionError) {
        onShowError(
          AppError<AssertionError>(
            message: ex.message?.toString() ?? ex.toString(),
            response: ex,
          ),
        );
      }
    }, test: (ex) => ex is AssertionError).catchError((ex) {
      throw (ex);
    });
  }

  /// Displays the loading infront of all
  ///
  ///
  Future<T> showOverlayProgress(
      {required BuildContext context, double bgOpacity = 0.30}) {
    OverlayEntry? progressOverlay;

    progressOverlay = OverlayEntry(
      builder: (context) => AbsorbPointer(
        absorbing: true,
        child: Container(
          color: Colors.black..withValues(alpha: bgOpacity),
          alignment: Alignment.center,
          child: const AppProgressWidget(),
        ),
      ),
    );
    Overlay.of(context).insert(progressOverlay);

    return whenComplete(() {
      if (progressOverlay != null) {
        progressOverlay!.remove();
        progressOverlay = null;
      }
    });
  }
}

///
///
///custom log. [eg: myLog('aswin','name');]
///
myLog(dynamic value, [String name = '', bool ignoreConsole = false]) {
  AppStackInterceptorBuilder.log = '@$name $value';
  if (kDebugMode && !ignoreConsole) {
    try {
      ///checks if the value can be print in structured json
      log({'@$name': const JsonEncoder.withIndent(' ').convert(value)}
          .toString());
    } on FormatException {
      ///if the value is not json String treats as plain text
      log({'@$name': value}.toString());
    }
  }
}

extension Logger<E> on E {
  ///
  ///can print any variable from anywhere.
  ///[new_method]
  ///```dart
  ///@override
  /// Widget build(BuildContext context) {
  ///   return Widget(
  ///   //able to log with the parameter.
  ///     child:paramClass.log().value.log('list').lenght.log('length of list'),
  ///   ),
  /// }
  ///```
  ///[normal_method]
  ///```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  //have to print the variable before the return statement
  ///   print(paramClass.value.lenght);
  ///   return Widget(
  ///     child:paramClass.value.lenght,
  ///   ),
  ///}
  ///```

  E log([String key = '', bool ignoreConsole = false]) {
    myLog(this, key, ignoreConsole);
    // showToast("$key $this ");
    return this;
  }
}

/// The extension for the [Widget]
///
///
extension WidgetExtension on Widget {
  /// For the app the common padding is `28` in horizontal
  ///
  /// This extension will add an horizontal padding to the elements
  Widget withScreenPadding({double padding = 16}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: this,
      );

  Widget withScreenshotImg({required String imgUrl, double opacity = 0.5}) =>
      Stack(
        children: [
          Positioned.fill(child: this),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Opacity(
                opacity: opacity,
                child: Image.network(
                  imgUrl,
                  colorBlendMode: BlendMode.colorBurn,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );

  /// Shows the progress widget on the center of the [Widget]
  Widget showProgressOnCenter<P extends MixinProgressProvider?>({
    double bgOpacity = 0.15,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(absorbing: provider?.isLoading ?? false, child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: bgOpacity),
                    borderRadius: borderRadius,
                  ),
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter2<P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?>({
    double bgOpacity = 0.15,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Consumer2<P, P2>(
        builder: (context, p, p2, _) {
          bool? isloading = (p?.isLoading ?? false) || (p2?.isLoading ?? false);
          return Stack(
            children: [
              AbsorbPointer(absorbing: isloading, child: this),
              if (isloading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor
                        ..withValues(alpha: bgOpacity),
                      borderRadius: borderRadius,
                    ),
                    child: const AppProgressWidget(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter3<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer3<P, P2, P3>(
        builder: (context, p, p2, p3, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (p?.isLoading ?? false) ||
                    (p2?.isLoading ?? false) ||
                    (p3?.isLoading ?? false),
                child: this),
            if ((p?.isLoading ?? false) ||
                (p2?.isLoading ?? false) ||
                (p3?.isLoading ?? false))
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context)
                      .dividerColor
                      .withValues(alpha: bgOpacity),
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter4<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?,
          P4 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer4<P, P2, P3, P4>(
        builder: (context, p, p2, p3, p4, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: ((p?.isLoading ?? false) ||
                    (p2?.isLoading ?? false) ||
                    (p3?.isLoading ?? false) ||
                    (p4?.isLoading ?? false)),
                child: this),
            if ((p?.isLoading ?? false) ||
                (p2?.isLoading ?? false) ||
                (p3?.isLoading ?? false) ||
                (p4?.isLoading ?? false))
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).dividerColor
                    ..withValues(alpha: bgOpacity),
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget showCircleProgressOnCenter<P extends MixinProgressProvider?>(
          {double bgOpacity = 0.30}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context)
                      .dividerColor
                      .withValues(alpha: bgOpacity),
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget showGreyProgressOnCenter<P extends MixinProgressProvider?>(
          {double bgOpacity = 0.30}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context)
                      .dividerColor
                      .withValues(alpha: bgOpacity),
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget showProgressOnCenter5<
              P extends MixinProgressProvider?,
              P2 extends MixinProgressProvider?,
              P3 extends MixinProgressProvider?,
              P4 extends MixinProgressProvider?,
              P5 extends MixinProgressProvider?>(
          {double bgOpacity = 0.45, bool isProgress2 = false}) =>
      Consumer5<P, P2, P3, P4, P5>(
        builder: (context, p, p2, p3, p4, p5, _) {
          bool isLoading = ((p?.isLoading ?? false) ||
              (p2?.isLoading ?? false) ||
              (p3?.isLoading ?? false) ||
              (p4?.isLoading ?? false) ||
              (p5?.isLoading ?? false));
          return Stack(
            children: [
              IgnorePointer(ignoring: isLoading, child: this),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: bgOpacity),
                    child: isProgress2
                        ? const AppProgressWidget()
                        : const AppProgressWidget(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter6<
          P extends MixinProgressProvider?,
          P2 extends MixinProgressProvider?,
          P3 extends MixinProgressProvider?,
          P4 extends MixinProgressProvider?,
          P5 extends MixinProgressProvider?,
          P6 extends MixinProgressProvider?>({double bgOpacity = 0.45}) =>
      Consumer6<P, P2, P3, P4, P5, P6>(
        builder: (context, p, p2, p3, p4, p5, p6, _) {
          bool isLoading = ((p?.isLoading ?? false) ||
              (p2?.isLoading ?? false) ||
              (p3?.isLoading ?? false) ||
              (p4?.isLoading ?? false) ||
              (p5?.isLoading ?? false) ||
              (p6?.isLoading ?? false));
          return Stack(
            children: [
              AbsorbPointer(absorbing: isLoading, child: this),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context)
                        .dividerColor
                        .withValues(alpha: bgOpacity),
                    child: const AppProgressWidget(),
                  ),
                ),
            ],
          );
        },
      );

  Widget showProgressOnCenter1<P extends MixinProgressProvider?>(
          {Color bgColor = Colors.transparent}) =>
      Consumer<P>(
        builder: (context, provider, _) => Stack(
          children: [
            AbsorbPointer(
                absorbing: (provider?.isLoading ?? false), child: this),
            if (provider?.isLoading ?? false)
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: bgColor,
                  child: const AppProgressWidget(),
                ),
              ),
          ],
        ),
      );

  Widget orShowEmptyWidget({
    required List? items,
    bool isLoading = false,
    String text = "No records found",
    double bottomPadding = 0.0,
    double iconTopPadding = 0.0,
  }) {
    if (isLoading) return this;
    if (items?.isEmpty ?? true) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: iconTopPadding),
            //   child: const Text("Empty"),
            // ),
            SvgPicture.asset(
              'empty_state'.asAssetSvg(),
              height: 135,
              width: 135,
            ),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFFA3A3A3),
                fontSize: 19,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     top: 16,
            //     bottom: bottomPadding,
            //   ),
            //   child: Text(
            //     text,
            //     style: const TextStyle(
            //       color: Color(0xFFA3A3A3),
            //       fontSize: 21,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        )),
      );
    }
    return this;
  }

  // Widget orShowEmptySearchWidget({
  //   @required List? items,
  //   bool isLoading = false,
  //   String text1 = '',
  //   String text2 = "No search data",
  //   GestureTapCallback? onTap,
  //   required bool isShowSecondText,
  // }) {
  //   if (isLoading) return this;
  //   if (!isShowSecondText) {
  //     return Center(
  //       child: Column(
  //         children: [
  //           InkWell(
  //             child: Container(
  //               margin: EdgeInsets.only(
  //                   left: SizeConfig.getWidth(15),
  //                   right: SizeConfig.getWidth(15)),
  //               padding: EdgeInsets.all(SizeConfig.getWidth(10)),
  //               child: RichText(
  //                 text: TextSpan(
  //                     text: text1,
  //                     style: TextStyle(color: Colors.grey, fontSize: 13),
  //                     children: <TextSpan>[
  //                       TextSpan(
  //                         text: text2,
  //                         style: TextStyle(
  //                           color: Colors.black87,
  //                           fontSize: 13,
  //                         ),
  //                       )
  //                     ]),
  //               ),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5)),
  //             ),
  //             onTap: onTap,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return this;
  // }

  Widget orShowEmptyWidget1({
    required List? items,
    bool isLoading = false,
    String text = "No records found",
    double bottomPadding = 0.0,
    double iconTopPadding = 0.0,
  }) {
    if (isLoading) return this;
    if (items?.isEmpty ?? true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            'empty_state'.asAssetSvg(),
            height: 100,
            width: 100,
          ),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFFA3A3A3),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return this;
  }
}

extension BuildContextExtension on BuildContext {
  T? getScreenParamsOf<T>() {
    try {
      return ModalRoute.of(this)!.settings.arguments as T;
    } catch (ex) {
      debugPrint(ex.toString());
    }
    return null;
  }
}

extension DateTimeExtension on DateTime {
  DateTime roundToCeil() {
    DateTime returnTime = this;
    if (returnTime.minute % 5 != 0) {
      final roundedMinutes = 5 * (returnTime.minute / 5).ceil();
      final diff = roundedMinutes - returnTime.minute;
      if (diff != 0) {
        returnTime = returnTime.add(Duration(minutes: diff));
      }
    }
    return returnTime;
  }

  String? toFormatted({
    String format = "dd/MM/yyy",
    bool useToday = true,
    bool useYestaerday = true,
    String todayTimeFormat = "hh:mm a",
    String yesterdayTimeFormat = "hh:mm a",
  }) {
    try {
      final current = DateTime.now();
      final diff = DateTime(current.year, current.month, current.day)
          .difference(DateTime(year, month, day))
          .inDays;
      if (useToday && diff == 0) {
        return "Today, ${DateFormat(todayTimeFormat).format(this)}";
      }
      if (useYestaerday && diff == 1) {
        return "Yesterday, ${DateFormat(yesterdayTimeFormat).format(this)}";
      }
      return DateFormat(format).format(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

extension DynamicExtension on dynamic {
  double? toDouble() {
    try {
      if (this?.toString().isEmpty ?? true) {
        return null;
      }
      return double.parse(this?.toString() ?? "");
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

extension DoubleExtension on double? {
  double? toFormattedDecimal(int decimals) {
    if (this == null) return null;

    int maxDigits = 10;

    if (decimals > maxDigits) {
      maxDigits = decimals + 1;
    }
    String valStr = this!.toStringAsFixed(maxDigits);
    final splits = valStr.split('.');
    valStr = "${splits[0]}.${splits[1].substring(0, decimals)}";
    return double.parse(valStr);
  }

  String? toEstimatedDiffAmount() {
    if (this == null) return null;
    return "${(this?.toDouble().toStringAsFixed(2) ?? 0)} - ${((this?.toDouble() ?? 0) + 30).toStringAsFixed(2)}";
  }
}

extension ListViewExtension on ListView {
  Widget withLoadMore({
    required void Function(BuildContext context) onLoadMore,
    required bool Function(BuildContext context) canLoadMore,
  }) =>
      ListScrollMoreWidget(
        onLoadMore: onLoadMore,
        canLoadMore: canLoadMore,
        child: this,
      );
}

extension GridViewExtension on GridView {
  Widget withLoadMore({
    required void Function(BuildContext context) onLoadMore,
    required bool Function(BuildContext context) canLoadMore,
  }) =>
      GridScrollMoreWidget(
        onLoadMore: onLoadMore,
        canLoadMore: canLoadMore,
        child: this,
      );
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrentRoute(routeName)) {
      pushNamed(routeName, arguments: arguments);
    } else {
      pop();
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
