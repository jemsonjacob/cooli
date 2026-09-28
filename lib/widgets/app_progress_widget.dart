import 'package:flutter/material.dart';

class AppProgressWidget extends StatelessWidget {
  const AppProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: 28,
      height: 28,
      child: const FittedBox(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
