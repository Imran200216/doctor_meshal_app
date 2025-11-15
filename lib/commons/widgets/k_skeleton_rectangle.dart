import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KSkeletonRectangle extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const KSkeletonRectangle({
    super.key,
    this.height = 50,
    this.width = double.infinity,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: ShimmerEffect(),
      enabled: true,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColorConstants.subTitleColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
