import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_profile_avatar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class ChatListTile extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String message;
  final String time;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.message,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ListTile(
      onTap: () {
        // Haptics
        HapticFeedback.heavyImpact();

        // on Tap
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

      title: Text(name),
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

      subtitle: Text(message),
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

      trailing: Text(time),
      leadingAndTrailingTextStyle: TextStyle(
        color: AppColorConstants.subTitleColor,
        fontWeight: FontWeight.w600,
        fontFamily: "OpenSans",
        fontSize: isMobile
            ? 12
            : isTablet
            ? 14
            : 16,
      ),
    );
  }
}
