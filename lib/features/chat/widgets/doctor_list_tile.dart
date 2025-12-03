import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class DoctorListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String profileImageUrl;
  final String doctorName;
  final String doctorDesignation;

  const DoctorListTile({
    super.key,
    required this.profileImageUrl,
    required this.doctorName,
    required this.doctorDesignation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ListTile(

      splashColor: AppColorConstants.transparentColor,
      hoverColor: AppColorConstants.transparentColor,
      focusColor: AppColorConstants.transparentColor,
      tileColor: AppColorConstants.transparentColor,

      onTap: () {
        // Haptics
        HapticFeedback.heavyImpact();

        // on tap
        onTap();
      },
      contentPadding: EdgeInsets.zero,
      leading: KProfileAvatar(
        personImageUrl: profileImageUrl,
        width: isMobile
            ? 60
            : isTablet
            ? 65
            : 70,
        height: isMobile
            ? 60
            : isTablet
            ? 65
            : 70,
      ),

      title: Text(doctorName),
      titleTextStyle: TextStyle(
        color: AppColorConstants.titleColor,
        fontWeight: FontWeight.w600,
        fontFamily: "OpenSans",
        fontSize: isMobile
            ? 18
            : isTablet
            ? 20
            : 22,
        overflow: TextOverflow.ellipsis,
      ),

      subtitle: Text(doctorDesignation),
      subtitleTextStyle: TextStyle(
        color: AppColorConstants.subTitleColor,
        fontWeight: FontWeight.w500,
        fontFamily: "OpenSans",
        fontSize: isMobile
            ? 14
            : isTablet
            ? 16
            : 18,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
