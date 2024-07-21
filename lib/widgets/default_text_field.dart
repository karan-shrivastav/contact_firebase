import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? color;
  final Color? hintColor;
  final Color? enteredTextColor;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final Color? cursorColor;
  final bool? obscureText;
  final int? maxLength;
  final TextInputType? textInputType;
  const DefaultTextField({
    super.key,
    this.controller,
    this.hintText,
    this.color,
    this.hintColor,
    this.enteredTextColor,
    this.onChanged,
    this.suffixIcon,
    this.contentPadding,
    this.cursorColor,
    this.obscureText,
    this.maxLength,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        obscureText: obscureText ?? false,
        cursorColor: cursorColor,

        maxLength: maxLength,
        maxLines: 1,
        keyboardType: textInputType ?? TextInputType.text,
        style: TextStyle(
          color: enteredTextColor,
        ),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: hintText,
          suffix: suffixIcon,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: hintColor,
          ),
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
