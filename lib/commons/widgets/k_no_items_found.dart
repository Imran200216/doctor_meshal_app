import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class KNoItemsFound extends StatelessWidget {
  final String? noItemsSvg; // optional
  final String? noItemsFoundText; // optional

  const KNoItemsFound({super.key, this.noItemsSvg, this.noItemsFoundText});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final appLoc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            noItemsSvg ?? AppAssetsConstants.empty,
            height: isMobile
                ? 200
                : isTablet
                ? 240
                : 280,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),

          KText(
            text: noItemsFoundText ?? appLoc.noItemsFound,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColorConstants.titleColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
