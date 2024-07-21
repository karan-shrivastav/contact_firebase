import 'package:flutter/material.dart';
import 'package:flutter_contact_firebase/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final Color? color;
  final Color? titleColor;
  const ButtonWidget({
    super.key,
    this.title,
    this.color,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color ?? const Color(0xFF778beb),
          borderRadius: BorderRadius.circular(25)),
      child: TextWidget(
        text: title,
        textAlign: TextAlign.center,
        color: titleColor ?? Colors.white,
      ),
    );
  }
}
