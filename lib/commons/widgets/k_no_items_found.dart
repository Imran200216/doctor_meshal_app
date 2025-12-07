import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

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

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: KText(
              softWrap: true,
              maxLines: 3,
              text: noItemsFoundText ?? appLoc.noItemsFound,
              fontSize: isMobile
                  ? 18
                  : isTablet
                  ? 20
                  : 24,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.titleColor,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
