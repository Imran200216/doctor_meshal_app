import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final bool? softWrap; // ✅ Optional softWrap

  const KText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.textDecoration,
    this.fontStyle,
    this.softWrap, // ✅ Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap ?? true, // ✅ Default to true
      style: TextStyle(
        fontFamily: "OpenSans",
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        letterSpacing: letterSpacing,
        height: height,
        decoration: textDecoration,
        fontStyle: fontStyle,
      ),
    );
  }
}
