import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import '../widgets/auth_app_bar.dart' show AuthAppBar;

class AuthOtpScreen extends StatelessWidget {
  const AuthOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Pinput theme
    final defaultPinTheme = PinTheme(
      width: isMobile
          ? 50
          : isTablet
          ? 60
          : 70,
      height: isMobile
          ? 56
          : isTablet
          ? 66
          : 76,
      textStyle: TextStyle(
        fontSize: isMobile
            ? 20
            : isTablet
            ? 24
            : 28,
        fontWeight: FontWeight.w600,
        color: AppColorConstants.titleColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColorConstants.subTitleColor.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColorConstants.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColorConstants.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColorConstants.primaryColor.withOpacity(0.05),
        border: Border.all(color: AppColorConstants.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: AuthAppBar(
        onBackTap: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              KText(
                text: appLoc.enterVerificationCode,
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
                text: "${appLoc.otpSubTitle} imran@babuji162002@gmail.com",
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

              // OTP Input
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                cursor: Container(
                  width: 2,
                  height: 24,
                  color: AppColorConstants.primaryColor,
                ),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                autofocus: true,
                keyboardType: TextInputType.number,
                onSubmitted: (value) {

                },
              ),

              const SizedBox(height: 20),

              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Didn't receive the code
                  KText(
                    text: appLoc.receiveCode,
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

                  // Didn't receive the code
                  GestureDetector(
                    onTap: () {
                      // Auth Change Password Screen
                      GoRouter.of(context).pushReplacementNamed(
                        AppRouterConstants.authChangePassword,
                      );
                    },
                    child: KText(
                      text: appLoc.tapToResend,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: 3,
                      fontSize: isMobile
                          ? 16
                          : isTablet
                          ? 18
                          : 20,
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
