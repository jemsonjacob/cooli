import 'package:flutter/material.dart';

class ListScrollMoreWidget extends StatelessWidget {
  final ListView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  ListScrollMoreWidget({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
  })  : assert(child.controller != null);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            if (canLoadMore(context)) onLoadMore(context);
          }
          return true;
        },
        child: child);
  }
}

class GridScrollMoreWidget extends StatelessWidget {
  final GridView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  GridScrollMoreWidget({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
  })  : assert(child.controller != null);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            if (canLoadMore(context)) onLoadMore(context);
          }
          return true;
        },
        child: child);
  }
}
