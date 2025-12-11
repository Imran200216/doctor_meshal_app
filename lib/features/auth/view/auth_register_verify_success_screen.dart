import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';

class AuthRegisterVerifySuccessScreen extends StatefulWidget {
  const AuthRegisterVerifySuccessScreen({super.key});

  @override
  State<AuthRegisterVerifySuccessScreen> createState() =>
      _AuthRegisterVerifySuccessScreenState();
}

class _AuthRegisterVerifySuccessScreenState
    extends State<AuthRegisterVerifySuccessScreen> {
  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: isMobile
                    ? 100
                    : isTablet
                    ? 120
                    : 140,
                color: AppColorConstants.primaryColor,
              ),

              const SizedBox(height: 30),
              // Title
              KText(
                text: appLoc.emailVerified,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                fontSize: isMobile
                    ? 22
                    : isTablet
                    ? 24
                    : 26,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.titleColor,
              ),

              const SizedBox(height: 12),

              // Sub Title
              KText(
                text: appLoc.emailVerifiedSubTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                maxLines: 3,
                fontSize: isMobile
                    ? 16
                    : isTablet
                    ? 18
                    : 20,
                fontWeight: FontWeight.w500,
                color: AppColorConstants.subTitleColor,
              ),

              const SizedBox(height: 30),

              // Continue Btn
              KFilledBtn(
                btnTitle: appLoc.continueWord,
                btnBgColor: AppColorConstants.primaryColor,
                btnTitleColor: AppColorConstants.secondaryColor,
                onTap: () {
                  // Patient Bottom Nav
                  GoRouter.of(
                    context,
                  ).pushReplacementNamed(AppRouterConstants.patientBottomNav);
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
