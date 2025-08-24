import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.overflow,
    this.maxLines,
    this.textAlign,
  });

  final String? text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: color ?? Colors.black,
      fontSize: size ?? 16,
      fontWeight: weight ?? FontWeight.normal,
    );

    return Text(
      text ?? '',
      style: textStyle,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}
