import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class NotificationListTile extends StatelessWidget {
  final String notificationTitle;
  final String notificationDescription;
  final String notificationDateReceived;

  const NotificationListTile({
    super.key,
    required this.notificationTitle,
    required this.notificationDescription,
    required this.notificationDateReceived,
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

      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      leading: Icon(
        Icons.notifications_active_outlined,
        color: AppColorConstants.primaryColor,
      ),

      trailing: KText(
        text: notificationDateReceived,
        fontSize: isMobile
            ? 14
            : isTablet
            ? 16
            : 18,
        fontWeight: FontWeight.w600,
        color: AppColorConstants.primaryColor,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: 2,
      ),

      title: Text(notificationTitle),
      titleTextStyle: TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w700,
        color: AppColorConstants.titleColor,
        fontSize: isMobile
            ? 18
            : isTablet
            ? 20
            : 22,
      ),

      subtitle: Text(
        notificationDescription,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      subtitleTextStyle: TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w500,
        color: AppColorConstants.subTitleColor,
        fontSize: isMobile
            ? 16
            : isTablet
            ? 18
            : 20,
      ),
    );
  }
}
