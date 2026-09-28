import 'colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> pickDate(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2010),
    lastDate: DateTime(2060),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors().primaryButtonColor,
          colorScheme:
              ColorScheme.light(primary: AppColors().primaryButtonColor),
          buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );

  final formattedDate = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
  return formattedDate;
}
