import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

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
                text: appLoc.registerSuccessfully,
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

              // Continue With Login Btn
              BlocConsumer<EmailAuthBloc, EmailAuthState>(
                listener: (context, state) async {
                  if (state is EmailAuthSuccess) {
                    KSnackBar.success(context, state.message);

                    // Login Screen
                    GoRouter.of(context).goNamed(AppRouterConstants.auth);

                    // Clear Box
                    await HiveService.clearBox(AppDBConstants.userBox);
                  }

                  if (state is EmailAuthError) {
                    Future.microtask(() {
                      KSnackBar.error(context, state.message);
                    });
                  }
                },
                builder: (context, state) {
                  return KFilledBtn(
                    btnTitle: appLoc.continueWithLogin,
                    btnBgColor: AppColorConstants.primaryColor,
                    btnTitleColor: AppColorConstants.secondaryColor,
                    onTap: () async {
                      // 1. Read data from Hive
                      final hiveData = await HiveService.getData(
                        boxName: AppDBConstants.userBox,
                        key: AppDBConstants.userAuthData,
                      );

                      if (hiveData == null) {
                        KSnackBar.error(
                          context,
                          "User data not found in Hive!",
                        );
                        return;
                      }

                      // 2. Convert to model
                      final userModel = UserAuthModel.fromJson(hiveData);

                      // 🔥 Log Data Before Passing to Bloc
                      AppLoggerHelper.logInfo("""
====== Passing Data to EmailAuthRegisterEvent ======
First Name  : ${userModel.firstName}
Last Name   : ${userModel.lastName}
Email       : ${userModel.email}
Password    : ${userModel.password}
Phone Code  : ${userModel.phoneCode}
Phone Number: ${userModel.phoneNumber}
====================================================
""");

                      // 3. Pass model data into Bloc Event
                      context.read<EmailAuthBloc>().add(
                        EmailAuthRegisterEvent(
                          firstName: userModel.firstName,
                          lastName: userModel.lastName,
                          email: userModel.email,
                          password: userModel.password,
                          phoneCode: userModel.phoneCode,
                          phoneNumber: userModel.phoneNumber,
                        ),
                      );
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
            ],
          ),
        ),
      ),
    );
  }
}
