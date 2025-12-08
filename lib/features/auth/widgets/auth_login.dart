import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

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
            validator: (value) => AppValidators.email(context, value),
          ),

          // Password Text Form Field
          KPasswordTextFormField(
            controller: _authPasswordLoginController,
            hintText: appLoc.enterPassword,
            labelText: appLoc.password,
            validator: (value) => AppValidators.password(context, value),
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
          MultiBlocListener(
            listeners: [
              // EmailAuthBloc Listener
              BlocListener<EmailAuthBloc, EmailAuthState>(
                listener: (context, state) async {
                  if (state is EmailAuthSuccess) {
                    // User Auth Logged Status
                    await HiveService.saveData(
                      boxName: AppDBConstants.userBox,
                      key: AppDBConstants.userAuthLoggedStatus,
                      value: true,
                    );

                    AppLoggerHelper.logInfo(
                      "User Logged Status saved successfully in Hive",
                    );

                    AppLoggerHelper.logInfo(
                      "EmailAuthSuccess → Triggering UserAuthBloc for userId: ${state.id}",
                    );

                    // Trigger fetching full user details
                    context.read<UserAuthBloc>().add(
                      GetUserAuthEvent(id: state.id, token: state.token),
                    );

                    // Show success message once
                    if (context.mounted) {
                      KSnackBar.success(context, appLoc.loginSuccess);
                    }

                    clearControllers();
                  }

                  if (state is EmailAuthError) {
                    AppLoggerHelper.logError(
                      "Email Auth Error: ${state.message}",
                    );
                    if (context.mounted) {
                      KSnackBar.error(context, state.message);
                    }
                  }
                },
              ),

              BlocListener<UserAuthBloc, UserAuthState>(
                listener: (context, state) {
                  if (state is GetUserAuthSuccess) {
                    final user = state.user;
                    final router = GoRouter.of(context);

                    // Log full user data before saving
                    AppLoggerHelper.logInfo(
                      "USER AUTH SUCCESS — FULL USER DATA:",
                    );
                    AppLoggerHelper.logInfo("ID: ${user.id}");
                    AppLoggerHelper.logInfo(
                      "Profile Image: ${user.profileImage}",
                    );
                    AppLoggerHelper.logInfo("First Name: ${user.firstName}");
                    AppLoggerHelper.logInfo("Last Name: ${user.lastName}");
                    AppLoggerHelper.logInfo("Email: ${user.email}");
                    AppLoggerHelper.logInfo("Phone Code: ${user.phoneCode}");
                    AppLoggerHelper.logInfo(
                      "Phone Number: ${user.phoneNumber}",
                    );
                    AppLoggerHelper.logInfo(
                      "Register Date: ${user.registerDate}",
                    );
                    AppLoggerHelper.logInfo("Age: ${user.age}");
                    AppLoggerHelper.logInfo("Gender: ${user.gender}");
                    AppLoggerHelper.logInfo("Height: ${user.height}");
                    AppLoggerHelper.logInfo("Weight: ${user.weight}");
                    AppLoggerHelper.logInfo("Blood Group: ${user.bloodGroup}");
                    AppLoggerHelper.logInfo("CID: ${user.cid}");
                    AppLoggerHelper.logInfo("Created At: ${user.createdAt}");
                    AppLoggerHelper.logInfo("Updated At: ${user.updatedAt}");
                    AppLoggerHelper.logInfo("User Type: ${user.userType}");

                    Future.delayed(const Duration(milliseconds: 400), () async {
                      try {
                        // Save full model
                        await HiveService.saveData(
                          boxName: AppDBConstants.userBox,
                          key: AppDBConstants.userAuthData,
                          value: user.toJson(),
                        );

                        AppLoggerHelper.logInfo(
                          "Full user data saved to Hive successfully",
                        );

                        // Routing
                        if (user.userType == 'patient') {
                          AppLoggerHelper.logInfo(
                            "Navigating to Patient Bottom Nav",
                          );
                          router.pushReplacementNamed(
                            AppRouterConstants.patientBottomNav,
                          );
                        } else if (user.userType == 'doctor' ||
                            user.userType == 'admin') {
                          AppLoggerHelper.logInfo(
                            "Navigating to Doctor Bottom Nav",
                          );
                          router.pushReplacementNamed(
                            AppRouterConstants.doctorBottomNav,
                          );
                        } else {
                          AppLoggerHelper.logInfo(
                            "Unknown user type, defaulting to Patient Nav",
                          );
                          router.pushReplacementNamed(
                            AppRouterConstants.patientBottomNav,
                          );
                        }
                      } catch (e) {
                        AppLoggerHelper.logError("Hive Save Error: $e");
                      }
                    });
                  }

                  if (state is GetUserAuthFailure) {
                    AppLoggerHelper.logError(
                      "Get User Auth Failure: ${state.message}",
                    );
                    if (context.mounted) {
                      KSnackBar.error(context, state.message);
                    }
                  }
                },
              ),
            ],
            child: BlocBuilder<EmailAuthBloc, EmailAuthState>(
              builder: (context, state) {
                return KFilledBtn(
                  isLoading: state is EmailAuthLoading,
                  btnTitle: appLoc.login,
                  btnBgColor: AppColorConstants.primaryColor,
                  btnTitleColor: AppColorConstants.secondaryColor,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final connectivityState = context
                          .read<ConnectivityBloc>()
                          .state;

                      // Correct internet check
                      if (connectivityState is ConnectivityFailure ||
                          (connectivityState is ConnectivitySuccess &&
                              connectivityState.isConnected == false)) {
                        KSnackBar.error(context, appLoc.noInternet);
                        return;
                      }

                      AppLoggerHelper.logInfo(
                        "Attempting login for email: ${_authEmailLoginController.text.trim()}",
                      );

                      AppLoggerHelper.logInfo(
                        "Check Token: ${FCMService.globalFcmToken}",
                      );
                      context.read<EmailAuthBloc>().add(
                        EmailAuthLoginEvent(
                          email: _authEmailLoginController.text.trim(),
                          password: _authPasswordLoginController.text.trim(),
                          fcmToken: FCMService.globalFcmToken,
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
          ),

          const SizedBox(height: 20),

          // Row(
          //   spacing: 20,
          //   children: [
          //     Expanded(
          //       child: Divider(
          //         color: AppColorConstants.subTitleColor.withOpacity(0.3),
          //         thickness: 1,
          //       ),
          //     ),
          //
          //     KText(
          //       text: appLoc.orContinueWith,
          //       textAlign: TextAlign.center,
          //       overflow: TextOverflow.visible,
          //       fontSize: isMobile
          //           ? 14
          //           : isTablet
          //           ? 16
          //           : 18,
          //       fontWeight: FontWeight.w500,
          //       color: AppColorConstants.subTitleColor,
          //     ),
          //
          //     Expanded(
          //       child: Divider(
          //         color: AppColorConstants.subTitleColor.withOpacity(0.3),
          //         thickness: 1,
          //       ),
          //     ),
          //   ],
          // ),
          //
          // const SizedBox(height: 20),
          //
          // // Google
          // SocialBtn(
          //   btnTitle: appLoc.continueWithGoogle,
          //   borderColor: AppColorConstants.subTitleColor.withOpacity(0.2),
          //   bgColor: Colors.white,
          //   textColor: AppColorConstants.titleColor,
          //   svgIcon: AppAssetsConstants.google,
          //   onTap: () {
          //     // Bottom Nav
          //     GoRouter.of(
          //       context,
          //     ).pushReplacementNamed(AppRouterConstants.bottomNav);
          //   },
          //   btnWidth: double.maxFinite,
          // ),
          //
          // if (!kIsWeb && Platform.isIOS)
          //   SocialBtn(
          //     btnTitle: appLoc.continueWithApple,
          //     borderColor: AppColorConstants.subTitleColor.withOpacity(0.2),
          //     bgColor: Colors.white,
          //     textColor: AppColorConstants.titleColor,
          //     svgIcon: AppAssetsConstants.apple,
          //     onTap: () {},
          //     btnWidth: double.maxFinite,
          //   )
          // else
          //   const SizedBox.shrink(),
        ],
      ),
    );
  }
}
