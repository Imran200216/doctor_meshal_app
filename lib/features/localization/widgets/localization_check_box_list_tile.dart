import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class LocalizationCheckBoxListTile extends StatelessWidget {
  final String checkBoxTitle;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const LocalizationCheckBoxListTile({
    super.key,
    required this.checkBoxTitle,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isChecked
              ? AppColorConstants.primaryColor
              : AppColorConstants.secondaryColor,
          border: Border.all(color: AppColorConstants.subTitleColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CheckboxListTile(
          title: Text(
            checkBoxTitle,
            style: TextStyle(
              fontSize: isMobile
                  ? 18
                  : isTablet
                  ? 20
                  : 22,
              fontWeight: FontWeight.w500,
              color: isChecked
                  ? AppColorConstants.secondaryColor
                  : AppColorConstants.titleColor,
            ),
          ),
          value: isChecked,
          activeColor: AppColorConstants.primaryColor,
          checkColor: AppColorConstants.secondaryColor,
          shape: const CircleBorder(),
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
