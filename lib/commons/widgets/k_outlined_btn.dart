import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class KOutlinedBtn extends StatelessWidget {
  final String btnTitle;
  final VoidCallback onTap;
  final bool isLoading;
  final double borderRadius;
  final double fontSize;
  final double btnHeight;
  final double btnWidth;
  final Color? borderColor;
  final Color? titleColor;

  const KOutlinedBtn({
    super.key,
    required this.btnTitle,
    required this.onTap,
    this.isLoading = false,
    required this.borderRadius,
    required this.fontSize,
    required this.btnHeight,
    required this.btnWidth,
    this.borderColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                onTap();
              },
        child: Container(
          height: btnHeight,
          width: btnWidth,
          decoration: BoxDecoration(
            color: Colors.transparent, // 👈 transparent background
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color:
                  borderColor ??
                  AppColorConstants.subTitleColor.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: btnHeight * 0.6,
                    width: btnHeight * 0.6,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        titleColor ?? AppColorConstants.titleColor,
                      ),
                      strokeWidth: 2,
                    ),
                  )
                : KText(
                    text: btnTitle,
                    fontSize: fontSize,
                    color: titleColor ?? AppColorConstants.titleColor,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
