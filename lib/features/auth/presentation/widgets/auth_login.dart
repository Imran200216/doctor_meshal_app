import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_password_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/widgets/social_btn.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  // Controller
  final TextEditingController authEmailLoginController =
      TextEditingController();
  final TextEditingController authPasswordLoginController =
      TextEditingController();

  @override
  void dispose() {
    authEmailLoginController.dispose();
    authPasswordLoginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Email Text Form Field
        KTextFormField(
          controller: authEmailLoginController,
          hintText: appLoc.enterEmail,
          labelText: appLoc.email,
          autofillHints: [AutofillHints.email],
        ),

        // Password Text Form Field
        KPasswordTextFormField(
          controller: authPasswordLoginController,
          hintText: appLoc.enterPassword,
          labelText: appLoc.password,
        ),

        // Forget Password Text Btn
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              // Auth Forget Password Screen
              GoRouter.of(
                context,
              ).pushNamed(AppRouterConstants.authForgetPassword);
            },
            child: KText(
              text: appLoc.forgetPassword,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.primaryColor,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Login Btn
        KFilledBtn(
          btnTitle: appLoc.login,
          btnBgColor: AppColorConstants.primaryColor,
          btnTitleColor: AppColorConstants.secondaryColor,
          onTap: () {},
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

        const SizedBox(height: 20),

        Row(
          spacing: 20,
          children: [
            Expanded(
              child: Divider(
                color: AppColorConstants.subTitleColor.withOpacity(0.3),
                thickness: 1,
              ),
            ),

            KText(
              text: appLoc.orContinueWith,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              fontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              fontWeight: FontWeight.w500,
              color: AppColorConstants.subTitleColor,
            ),

            Expanded(
              child: Divider(
                color: AppColorConstants.subTitleColor.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SocialBtn(
          btnTitle: appLoc.continueWithGoogle,
          borderColor: AppColorConstants.subTitleColor.withOpacity(0.2),
          bgColor: Colors.white,
          textColor: AppColorConstants.titleColor,
          svgIcon: AppAssetsConstants.google,
          onTap: () {
            // Bottom Nav
            GoRouter.of(
              context,
            ).pushReplacementNamed(AppRouterConstants.bottomNav);
          },
          btnWidth: double.maxFinite,
        ),

        if (!kIsWeb && Platform.isIOS)
          SocialBtn(
            btnTitle: appLoc.continueWithApple,
            borderColor: AppColorConstants.subTitleColor.withOpacity(0.2),
            bgColor: Colors.white,
            textColor: AppColorConstants.titleColor,
            svgIcon: AppAssetsConstants.apple,
            onTap: () {},
            btnWidth: double.maxFinite,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
