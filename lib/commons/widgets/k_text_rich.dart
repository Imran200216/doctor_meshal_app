import 'package:flutter/material.dart';

class KTextRich extends StatelessWidget {
  final List<InlineSpan> children;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KTextRich({
    super.key,
    required this.children,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.visible,
        text: TextSpan(
          children: children,
          style: const TextStyle(
            color: Colors.black, // Default text color
          ),
        ),
      ),
    );
  }
}
