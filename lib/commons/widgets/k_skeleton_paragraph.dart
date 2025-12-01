import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KSkeletonParagraph extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double radius;
  final double spacing;

  const KSkeletonParagraph({
    super.key,
    this.lines = 4,
    this.lineHeight = 14,
    this.radius = 6,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(),
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines, (index) {
          // last line is shorter for natural paragraph look
          final isLastLine = index == lines - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: index == lines - 1 ? 0 : spacing),
            child: Container(
              height: lineHeight,
              width: isLastLine
                  ? MediaQuery.sizeOf(context).width *
                        0.65 // shorter last line
                  : double.infinity,
              decoration: BoxDecoration(
                color: AppColorConstants.subTitleColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          );
        }),
      ),
    );
  }
}
