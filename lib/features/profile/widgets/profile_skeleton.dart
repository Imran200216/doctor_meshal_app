import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // My Account
              KSkeletonRectangle(width: 100, height: 30),

              // My Account Container
              KSkeletonRectangle(width: double.infinity, height: 130),

              // General
              KSkeletonRectangle(width: 100, height: 30),

              // My Account Container
              KSkeletonRectangle(width: double.infinity, height: 200),

              // Support
              KSkeletonRectangle(width: 100, height: 30),

              // Support Container
              KSkeletonRectangle(width: double.infinity, height: 160),

              // Logout Container
              KSkeletonRectangle(width: double.infinity, height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
