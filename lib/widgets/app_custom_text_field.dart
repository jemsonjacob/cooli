import 'package:cooli/utils/colors.dart';
import 'package:cooli/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool? password;
  final int? numberOfLines;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final VoidCallback? onSuffixTap;
  final String? Function(String? value)? validator;
  final TextInputType? kbType;
  final String? initialValue;
  final TextEditingController? controller;
  final bool? obscureText;
  final bool isMandatory;
  final bool isEnabled;
  final bool? isTextCapital;
  final VoidCallback? onClick;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final double? suffixWidgetWidth;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final bool enableRoundedBorder;
  final bool autoFocus;
  final double borderRadius;
  final EdgeInsetsGeometry? prefixPadding;
  final Color? borderColor;
  final Color? enabledBorderColor;
  final void Function(String)? onChanged;

  const CustomTextField(
      {super.key,
      this.textStyle,
      this.padding,
      this.label,
      this.hint,
      this.prefixWidget,
      this.suffixWidget,
      this.password,
      this.numberOfLines,
      this.focusNode,
      this.onSuffixTap,
      this.kbType,
      this.initialValue,
      this.controller,
      this.obscureText,
      this.validator,
      this.contentPadding,
      this.labelStyle,
      this.hintStyle,
      this.isMandatory = false,
      this.isEnabled = true,
      this.minLines = 1,
      this.isTextCapital = false,
      this.suffixWidgetWidth = 50,
      this.inputFormatters,
      this.textCapitalization = TextCapitalization.none,
      this.enableRoundedBorder = false,
      this.borderRadius = 14,
      this.onClick,
      this.borderColor,
      this.enabledBorderColor,
      this.prefixPadding,
      this.onChanged,
      this.autoFocus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16),
      child: FormField<String>(builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              RichText(
                text: TextSpan(
                    text: label,
                    style: labelStyle ?? tsS12W400.copyWith(color: AppColors().colorBlack),
                    children: [
                      if (isMandatory)
                        TextSpan(
                            text: " *",
                            style: tsS12W400.copyWith(color: AppColors().colorDE202B))
                    ]),
              ),
            if (label != null) const SizedBox(height: 6),
            SizedBox(
              child: GestureDetector(
                onTap: () {
                  if (!isEnabled) {
                    FocusScope.of(context).unfocus();
                    onClick?.call();
                  }
                },
                child: TextFormField(
                  autofocus: autoFocus,
                  validator: validator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorColor: AppColors().colorBlack,
                  controller: controller,
                  initialValue: initialValue,
                  onChanged: onChanged,
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  keyboardType: kbType,
                  focusNode: focusNode,
                  enabled: isEnabled,
                  textCapitalization: textCapitalization,
                  inputFormatters: inputFormatters,
                  maxLines: numberOfLines ?? 1,
                  minLines: minLines,
                  obscureText: password ?? false,
                  style: textStyle ?? tsS16W500.copyWith(color: AppColors().colorBlack),
                  decoration: InputDecoration(
                    filled: false,
                    contentPadding: prefixWidget == null
                        ? contentPadding ??
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
                        : contentPadding ??
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    isDense: true,
                    suffixIcon: suffixWidget != null
                        ? InkWell(
                            onTap: onSuffixTap,
                            child: SizedBox(
                              width: suffixWidgetWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: suffixWidget),
                              ),
                            ),
                          )
                        : null,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors().colorDE202B),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor ?? const Color(0xFF4F46E5), width: 1.5),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors().colorDE202B, width: 1.5),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: enabledBorderColor ?? const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: enabledBorderColor ?? const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    prefixIcon: prefixWidget != null
                        ? Padding(
                            padding: prefixPadding ??
                                const EdgeInsets.only(left: 12, top: 4, right: 8),
                            child: prefixWidget,
                          )
                        : null,
                    hintText: hint ?? '',
                    hintStyle:
                        hintStyle ?? tsS15W500.copyWith(color: AppColors().colorBDBDBD),
                  ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: AppColors().colorDE202B, fontSize: 12),
                ),
              ),
          ],
        );
      }),
    );
  }
}
