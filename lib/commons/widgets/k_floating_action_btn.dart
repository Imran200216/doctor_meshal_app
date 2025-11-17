import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class KFloatingActionBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String fabIconPath;
  final String heroTag;

  const KFloatingActionBtn({
    super.key,
    required this.onTap,
    required this.fabIconPath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: FloatingActionButton(
        heroTag: heroTag,
        backgroundColor: AppColorConstants.primaryColor,
        onPressed: () {
          HapticFeedback.heavyImpact();

          onTap();
        },
        child: SvgPicture.asset(
          fabIconPath,
          height: isMobile
              ? 30
              : isTablet
              ? 34
              : 38,
          color: AppColorConstants.secondaryColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
