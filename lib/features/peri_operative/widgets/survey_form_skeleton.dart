import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class SurveyFormSkeleton extends StatelessWidget {
  const SurveyFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: ListView.separated(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return KSkeletonRectangle(
            width: double.maxFinite,
            height: isMobile
                ? 150
                : isTablet
                ? 180
                : 200,
            radius: 10,
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemCount: 8,
      ),
    );
  }
}
