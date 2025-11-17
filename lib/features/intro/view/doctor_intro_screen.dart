import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class DoctorIntroScreen extends StatelessWidget {
  const DoctorIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.introBgColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 30
                : isTablet
                ? 30
                : 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doctor Image
              Image.asset(
                AppAssetsConstants.doctorIntro,
                height: isMobile
                    ? 340
                    : isTablet
                    ? 400
                    : 440,
              ),

              // Name
              KText(
                textAlign: TextAlign.center,
                text: appLoc.doctorName,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 22
                    : isTablet
                    ? 24
                    : 26,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.secondaryColor,
              ),

              const SizedBox(height: 20),

              // Meet Our International Expert
              KText(
                textAlign: TextAlign.center,
                text: appLoc.meetOurExpert,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 18
                    : isTablet
                    ? 20
                    : 22,
                fontWeight: FontWeight.w600,
                color: AppColorConstants.secondaryColor,
              ),

              const SizedBox(height: 20),

              // Designation
              KText(
                textAlign: TextAlign.center,
                text: appLoc.designation,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 18
                    : isTablet
                    ? 20
                    : 22,
                fontWeight: FontWeight.w600,
                color: AppColorConstants.secondaryColor,
              ),

              const SizedBox(height: 20),

              // Description
              KText(
                textAlign: TextAlign.center,
                text: appLoc.designationDescription,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 16
                    : isTablet
                    ? 18
                    : 20,
                fontWeight: FontWeight.w600,
                color: AppColorConstants.secondaryColor,
              ),

              const Spacer(flex: 1),

              // Continue
              KFilledBtn(
                btnTitle: appLoc.continueWord,
                btnBgColor: AppColorConstants.secondaryColor,
                btnTitleColor: AppColorConstants.primaryColor,
                onTap: () {
                  // Auth Intro Screen
                  GoRouter.of(
                    context,
                  ).pushReplacementNamed(AppRouterConstants.auth);
                },
                borderRadius: 12,
                fontSize: isMobile
                    ? 16
                    : isTablet
                    ? 18
                    : 20,
                btnHeight: isMobile
                    ? 50
                    : isTablet
                    ? 52
                    : 54,
                btnWidth: double.maxFinite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
