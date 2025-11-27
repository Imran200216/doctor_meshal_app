import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class AuthChangePasswordScreen extends StatefulWidget {
  final String email;

  const AuthChangePasswordScreen({super.key, required this.email});

  @override
  State<AuthChangePasswordScreen> createState() =>
      _AuthChangePasswordScreenState();
}

class _AuthChangePasswordScreenState extends State<AuthChangePasswordScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: AuthAppBar(
        onBackTap: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  text: appLoc.changePassword,
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
                  text: appLoc.changePasswordSubTitle,
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

                // Password Text Form Field
                KPasswordTextFormField(
                  controller: passwordController,
                  hintText: appLoc.enterPassword,
                  labelText: appLoc.password,
                  validator: (value) => AppValidators.password(context, value),
                  autofillHints: [
                    AutofillHints.password,
                    AutofillHints.newPassword,
                  ],
                ),

                const SizedBox(height: 20),

                // Confirm Password Text Form Field
                KPasswordTextFormField(
                  controller: confirmPasswordController,
                  hintText: appLoc.enterConfirmPassword,
                  labelText: appLoc.confirmPassword,
                  validator: (value) => AppValidators.confirmPassword(
                    context,
                    value,
                    passwordController.text.trim(),
                  ),
                  autofillHints: [
                    AutofillHints.password,
                    AutofillHints.newPassword,
                  ],
                ),

                const SizedBox(height: 50),

                // Change Password Btn
                BlocConsumer<EmailAuthBloc, EmailAuthState>(
                  listener: (context, state) {
                    if (state is EmailAuthChangePasswordSuccess) {
                      // Success Snack Bar
                      KSnackBar.success(
                        context,
                        "Password Changed Successfully",
                      );

                      // Auth Change Password Success Screen
                      GoRouter.of(
                        context,
                      ).pushNamed(AppRouterConstants.authChangePasswordSuccess);
                    }
                  },
                  builder: (context, state) {
                    return KFilledBtn(
                      isLoading: state is EmailAuthChangePasswordLoading,
                      btnTitle: appLoc.changePassword,
                      btnBgColor: AppColorConstants.primaryColor,
                      btnTitleColor: AppColorConstants.secondaryColor,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // Email Auth Change Password Event
                          context.read<EmailAuthBloc>().add(
                            EmailAuthChangePasswordEvent(
                              email: widget.email,
                              newPassword: passwordController.text.trim(),
                              confirmPassword: confirmPasswordController.text
                                  .trim(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
