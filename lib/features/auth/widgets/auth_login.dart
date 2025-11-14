import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_password_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_validator.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/widgets/social_btn.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController _authEmailLoginController =
      TextEditingController();
  final TextEditingController _authPasswordLoginController =
      TextEditingController();

  @override
  void dispose() {
    _authEmailLoginController.dispose();
    _authPasswordLoginController.dispose();
    super.dispose();
  }

  // Controllers
  void clearControllers() {
    _authEmailLoginController.clear();
    _authPasswordLoginController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Email Text Form Field
          KTextFormField(
            controller: _authEmailLoginController,
            hintText: appLoc.enterEmail,
            labelText: appLoc.email,
            autofillHints: [AutofillHints.email],
            validator: (value) => AppValidators.email(value),
          ),

          // Password Text Form Field
          KPasswordTextFormField(
            controller: _authPasswordLoginController,
            hintText: appLoc.enterPassword,
            labelText: appLoc.password,
            validator: (value) => AppValidators.password(value),
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
          BlocConsumer<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) async {
              if (state is EmailAuthSuccess) {
                // Get User Auth Event Functionality
                context.read<UserAuthBloc>().add(
                  GetUserAuthEvent(id: state.id, token: state.token),
                );

                try {
                  // Open box
                  await HiveService.openBox(AppDBConstants.userBox);

                  // Save User ID
                  await HiveService.saveData(
                    boxName: AppDBConstants.userBox,
                    key: AppDBConstants.userId,
                    value: state.id,
                  );

                  // Read it back properly
                  final userId = await HiveService.getData<String>(
                    boxName: AppDBConstants.userBox,
                    key: AppDBConstants.userId,
                  );

                  AppLoggerHelper.logInfo(
                    "User ID stored successfully in Hive: $userId",
                  );
                } catch (e) {
                  AppLoggerHelper.logError("Error storing User ID in Hive: $e");
                }

                // Navigate to Bottom Nav
                GoRouter.of(
                  context,
                ).pushReplacementNamed(AppRouterConstants.bottomNav);

                KSnackBar.success(context, appLoc.loginSuccess);

                // Clear Controllers
                clearControllers();
              } else if (state is EmailAuthError) {
                // Show error
                KSnackBar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return KFilledBtn(
                isLoading: state is EmailAuthLoading,
                btnTitle: appLoc.login,
                btnBgColor: AppColorConstants.primaryColor,
                btnTitleColor: AppColorConstants.secondaryColor,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // Email Auth Login Event
                    context.read<EmailAuthBloc>().add(
                      EmailAuthLoginEvent(
                        email: _authEmailLoginController.text.trim(),
                        password: _authPasswordLoginController.text.trim(),
                      ),
                    );
                  }
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
              );
            },
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

          //
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
      ),
    );
  }
}
