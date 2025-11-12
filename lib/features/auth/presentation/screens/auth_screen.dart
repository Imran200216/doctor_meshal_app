import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/cubit/auth_selected_type_cubit.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/widgets/auth_login.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/widgets/auth_register.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                  ? 40
                  : 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<AuthSelectedTypeCubit, AuthSelectedTypeState>(
                  builder: (context, state) {
                    final cubit = context.read<AuthSelectedTypeCubit>();
                    final selectedAuthType = cubit.selectedAuthType ?? 'login';

                    return Column(
                      spacing: 14,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        KText(
                          text: selectedAuthType == "login"
                              ? appLoc.loginTitle
                              : appLoc.registerTitle,
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

                        // Sub Title
                        KText(
                          text: selectedAuthType == "login"
                              ? appLoc.loginSubTitle
                              : appLoc.registerSubTitle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          fontSize: isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                          fontWeight: FontWeight.w500,
                          color: AppColorConstants.subTitleColor,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                BlocBuilder<AuthSelectedTypeCubit, AuthSelectedTypeState>(
                  builder: (context, state) {
                    final cubit = context.read<AuthSelectedTypeCubit>();
                    final selectedAuthType = cubit.selectedAuthType ?? 'login';

                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: SegmentedButton<String>(
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color?>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return AppColorConstants.primaryColor;
                                  }
                                  return Colors.grey.shade200;
                                }),
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color?>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return AppColorConstants.secondaryColor;
                                  }
                                  return Colors.black87;
                                }),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                            ),
                            textStyle: WidgetStateProperty.all(
                              const TextStyle(
                                fontSize: 16,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          segments: [
                            ButtonSegment(
                              value: 'login',
                              label: Text(appLoc.login),
                            ),
                            ButtonSegment(
                              value: 'register',
                              label: Text(appLoc.register),
                            ),
                          ],
                          selected: <String>{selectedAuthType},
                          onSelectionChanged: (newSelection) {
                            // Haptics
                            HapticFeedback.selectionClick();

                            // Select Auth Type Cubit
                            cubit.selectAuthType(newSelection.first);
                          },
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                BlocBuilder<AuthSelectedTypeCubit, AuthSelectedTypeState>(
                  builder: (context, state) {
                    final cubit = context.read<AuthSelectedTypeCubit>();
                    final selectedAuthType = cubit.selectedAuthType ?? 'login';

                    return selectedAuthType == 'login'
                        ? const AuthLogin()
                        : const AuthRegister();
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
