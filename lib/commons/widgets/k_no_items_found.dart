import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class KNoItemsFound extends StatelessWidget {
  const KNoItemsFound({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssetsConstants.empty,
            height: isMobile
                ? 200
                : isTablet
                ? 240
                : 280,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 16),

          KText(
            text: appLoc.noItemsFound,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.titleColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
