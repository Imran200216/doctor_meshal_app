import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class ProfileListTile extends StatelessWidget {
  final IconData prefixIcon;
  final String title;
  final VoidCallback onTap;

  const ProfileListTile({
    super.key,
    required this.prefixIcon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();

        onTap();
      },
      child: ListTile(
        splashColor: AppColorConstants.transparentColor,
        hoverColor: AppColorConstants.transparentColor,
        focusColor: AppColorConstants.transparentColor,
        tileColor: AppColorConstants.transparentColor,

        leading: Icon(prefixIcon, color: AppColorConstants.titleColor),
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w600,
          color: AppColorConstants.titleColor,
          fontSize: isMobile
              ? 16
              : isTablet
              ? 18
              : 20,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: isMobile
              ? 16
              : isTablet
              ? 18
              : 20,
          color: AppColorConstants.titleColor,
        ),
      ),
    );
  }
}
