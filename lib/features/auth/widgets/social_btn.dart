import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class SocialBtn extends StatelessWidget {
  final String btnTitle;
  final Color borderColor;
  final Color bgColor;
  final Color textColor;
  final String svgIcon; // now uses SVG instead of asset image
  final VoidCallback onTap;
  final double borderRadius;
  final double fontSize;
  final double btnHeight;
  final double btnWidth;
  final bool isLoading;

  const SocialBtn({
    super.key,
    required this.btnTitle,
    required this.borderColor,
    required this.bgColor,
    required this.textColor,
    required this.svgIcon,
    required this.onTap,
    this.borderRadius = 12,
    this.fontSize = 16,
    this.btnHeight = 50,
    required this.btnWidth,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          height: btnHeight,
          width: btnWidth,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 0.7),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
              height: btnHeight * 0.5,
              width: btnHeight * 0.5,
              child: CircularProgressIndicator.adaptive(
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColorConstants.secondaryColor,
                ),
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svgIcon,
                  height: btnHeight * 0.5,
                  width: btnHeight * 0.5,
                ),
                const SizedBox(width: 10),
                KText(
                  text: btnTitle,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
