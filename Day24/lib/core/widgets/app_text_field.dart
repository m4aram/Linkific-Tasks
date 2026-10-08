import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Form field with the app's look. Wraps [TextFormField] so every form
/// gets validation, a visible label (also read by screen readers) and a
/// hard length limit.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final maxLength = this.maxLength;
    final prefixIcon = this.prefixIcon;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      enabled: enabled,
      obscureText: obscureText,
      // Never offer to "learn" or autocorrect secrets.
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
