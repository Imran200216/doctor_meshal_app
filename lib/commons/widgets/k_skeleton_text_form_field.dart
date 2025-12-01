import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KSkeletonTextFormField extends StatelessWidget {
  const KSkeletonTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label skeleton
          Container(
            height: 14,
            width: 120,
            decoration: BoxDecoration(
              color: AppColorConstants.subTitleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),

          // TextFormField skeleton
          Container(
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColorConstants.subTitleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
