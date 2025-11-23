import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class OperativeFormCard extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final String title;
  final String operationCardStartFormOrViewFormText;

  const OperativeFormCard({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
    required this.operationCardStartFormOrViewFormText,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

        onTap();
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColorConstants.secondaryColor,
          border: Border.all(
            color: AppColorConstants.subTitleColor.withOpacity(0.2),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Icon
            SvgPicture.asset(
              icon,
              color: AppColorConstants.primaryColor,
              height: isMobile
                  ? 36
                  : isTablet
                  ? 38
                  : 40,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 6),

            // Peri Operative Text
            KText(
              textAlign: TextAlign.start,
              text: title,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w700,
              color: AppColorConstants.titleColor,
            ),

            const SizedBox(height: 6),

            // Start Form
            Row(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                KText(
                  textAlign: TextAlign.start,
                  text: operationCardStartFormOrViewFormText,
                  fontSize: isMobile
                      ? 13
                      : isTablet
                      ? 16
                      : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.primaryColor,
                ),

                Icon(
                  Icons.arrow_forward,
                  color: AppColorConstants.primaryColor,
                  size: isMobile
                      ? 20
                      : isTablet
                      ? 22
                      : 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
