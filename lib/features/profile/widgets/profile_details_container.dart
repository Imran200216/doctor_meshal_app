import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class ProfileDetailsContainer extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String email;

  const ProfileDetailsContainer({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColorConstants.subTitleColor.withOpacity(0.05),
      ),
      child: Row(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile Image
          CircleAvatar(
            radius: isMobile
                ? 40
                : isTablet
                ? 44
                : 48,
            backgroundImage: NetworkImage(profileImageUrl),
          ),

          Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Person Name
              KText(
                text: name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 20
                    : isTablet
                    ? 22
                    : 24,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.titleColor,
              ),

              // Person Email
              KText(
                text: email,
                textAlign: TextAlign.start,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 16
                    : isTablet
                    ? 18
                    : 20,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.subTitleColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
