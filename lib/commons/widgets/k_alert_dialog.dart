import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class KAlertDialog extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final String titleText;
  final String contentText;
  final VoidCallback onCancelTap;
  final VoidCallback onConfirmTap;

  const KAlertDialog({
    super.key,
    required this.cancelText,
    required this.confirmText,
    required this.titleText,
    required this.contentText,
    required this.onCancelTap,
    required this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        titleText,
        style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: isMobile
              ? 18
              : isTablet
              ? 20
              : 22,
          fontWeight: FontWeight.w600,
          color: AppColorConstants.primaryColor,
        ),
      ),
      content: Text(
        contentText,
        style: TextStyle(
          fontFamily: "OpenSans",
          fontSize: isMobile
              ? 15
              : isTablet
              ? 17
              : 19,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            onCancelTap();
          },
          child: Text(
            cancelText,
            style: TextStyle(
              fontFamily: "OpenSans",
              fontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              color: AppColorConstants.subTitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Back Button
        TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            onConfirmTap();
          },
          child: Text(
            confirmText,
            style: TextStyle(
              fontFamily: "OpenSans",
              fontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
