import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
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
            KProfileAvatar(
              personImageUrl: profileImageUrl,
              width: isMobile
                  ? 90
                  : isTablet
                  ? 100
                  : 110,
              height: isMobile
                  ? 90
                  : isTablet
                  ? 100
                  : 110,
            ),

            Expanded(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Person Name
                  KText(
                    text: name,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                    maxLines: 3,
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
                    softWrap: true,
                    maxLines: 3,
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
            ),
          ],
        ),
      ),
    );
  }
}
