import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';


class PeriOperativeScoreCard extends StatelessWidget {
  final String totalCount;
  final String scoreCardTitle;
  final IconData icon;

  const PeriOperativeScoreCard({
    super.key,
    required this.totalCount,
    required this.scoreCardTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColorConstants.secondaryColor,
        border: Border.all(
          color: AppColorConstants.subTitleColor.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColorConstants.primaryColor,
            ),
            child: Center(
              child: Icon(
                icon,
                size: isMobile
                    ? 28
                    : isTablet
                    ? 30
                    : 32,
                color: AppColorConstants.secondaryColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Count
          KText(
            textAlign: TextAlign.start,
            text: totalCount,
            fontSize: isMobile
                ? 24
                : isTablet
                ? 26
                : 28,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.titleColor,
          ),

          const SizedBox(height: 2),

          // Total Form Submits
          KText(
            textAlign: TextAlign.start,
            text: scoreCardTitle,
            fontSize: isMobile
                ? 14
                : isTablet
                ? 16
                : 18,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.titleColor,
          ),
        ],
      ),
    );
  }
}
