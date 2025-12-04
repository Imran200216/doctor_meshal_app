import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class HomeDrawerListTile extends StatelessWidget {
  final String homeListTitle;
  final IconData iconData;
  final VoidCallback homeListTitleTap;

  const HomeDrawerListTile({
    super.key,
    required this.homeListTitle,
    required this.homeListTitleTap, required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ListTile(
      title: Text(homeListTitle),
      leading: Icon(
        iconData,
        color: AppColorConstants.titleColor,
      ),
      onTap: () {
        HapticFeedback.heavyImpact();

        homeListTitleTap();
      },
      titleTextStyle: TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w600,
        color: AppColorConstants.titleColor,
        fontSize: isMobile
            ? 18
            : isTablet
            ? 20
            : 22,
      ),
    );
  }
}
