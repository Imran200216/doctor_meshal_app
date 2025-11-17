import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_alert_dialog.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/widgets/auth_app_bar.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class AuthOtpScreen extends StatefulWidget {
  final String message;
  final String email;
  final String token;

  const AuthOtpScreen({
    super.key,
    required this.message,
    required this.email,
    required this.token,
  });

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  // 3 Minutes
  late Timer _timer;
  int _secondsRemaining = 180;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Start Timer
  void startTimer() {
    _secondsRemaining = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // Formatted Time
  String get formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Pin put theme
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

    // Focused Pin put theme
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

    // Submitted Pin put theme
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
          // Alert Dialog
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return KAlertDialog(
                cancelText: appLoc.cancel,
                confirmText: appLoc.confirm,
                titleText: appLoc.areYouSure,
                contentText: appLoc.cancelOTPVerifyProcess,
                onCancelTap: () {
                  // Back
                  GoRouter.of(context).pop();
                },
                onConfirmTap: () {
                  // stop Timer
                  _timer.cancel();

                  // Dialog Close
                  GoRouter.of(context).pop();

                  // Back
                  GoRouter.of(context).pop();
                },
              );
            },
          );
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
                text: widget.message,
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
              BlocConsumer<EmailAuthBloc, EmailAuthState>(
                listener: (context, state) {
                  if (state is EmailAuthOTPVerificationSuccess) {
                    if (state.status == true) {
                      KSnackBar.success(context, "OTP Verified Successfully");
                      GoRouter.of(context).pushReplacementNamed(
                        AppRouterConstants.authChangePassword,
                        extra: widget.email,
                      );
                    } else {
                      KSnackBar.error(context, state.message);
                    }
                  }

                  if (state is EmailAuthOTPVerificationFailure) {
                    KSnackBar.error(context, state.message);
                  }

                  if (state is EmailAuthResendOTPSuccess) {
                    if (state.success) {
                      KSnackBar.success(context, state.message);
                    } else {
                      KSnackBar.error(context, state.message);
                    }
                  }

                  if (state is EmailAuthResendOTPFailure) {
                    KSnackBar.error(context, state.message);
                  }
                },
                builder: (context, state) {
                  String otpToken = widget.token;

                  if (state is EmailAuthResendOTPSuccess) {
                    otpToken = state.token;
                  }

                  return Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    keyboardType: TextInputType.number,
                    onCompleted: (value) {
                      context.read<EmailAuthBloc>().add(
                        EmailAuthVerifyOTPEvent(
                          email: widget.email,
                          otp: value,
                          token: otpToken,
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              // Timer Display
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile
                      ? 16
                      : isTablet
                      ? 20
                      : 24,
                  vertical: isMobile
                      ? 10
                      : isTablet
                      ? 12
                      : 14,
                ),
                decoration: BoxDecoration(
                  color: _secondsRemaining > 0
                      ? AppColorConstants.primaryColor.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _secondsRemaining > 0
                        ? AppColorConstants.primaryColor.withOpacity(0.3)
                        : AppColorConstants.errorBorderColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _secondsRemaining > 0
                          ? Icons.timer_outlined
                          : Icons.timer_off_outlined,
                      color: _secondsRemaining > 0
                          ? AppColorConstants.primaryColor
                          : AppColorConstants.errorBorderColor,
                      size: isMobile
                          ? 20
                          : isTablet
                          ? 22
                          : 24,
                    ),
                    const SizedBox(width: 8),

                    KText(
                      text: _secondsRemaining > 0
                          ? "${appLoc.codeExpiresIn} $formattedTime"
                          : appLoc.codeExpired,
                      fontSize: isMobile
                          ? 14
                          : isTablet
                          ? 16
                          : 18,
                      fontWeight: FontWeight.w600,
                      color: _secondsRemaining > 0
                          ? AppColorConstants.primaryColor
                          : AppColorConstants.errorBorderColor,
                    ),
                  ],
                ),
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
                  BlocConsumer<EmailAuthBloc, EmailAuthState>(
                    listener: (context, state) {
                      if (state is EmailAuthResendOTPSuccess) {
                        if (state.success == true) {
                          // Success
                          KSnackBar.success(context, state.message);
                        } else {
                          // Failure from server
                          KSnackBar.error(context, state.message);
                        }
                      } else if (state is EmailAuthResendOTPFailure) {
                        KSnackBar.error(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      bool canResend = _secondsRemaining == 0;

                      return GestureDetector(
                        onTap: () {
                          if (!canResend) {
                            // Error Snack bar
                            KSnackBar.error(context, appLoc.timerIsRunning);
                            return;
                          }

                          // Resend OTP
                          context.read<EmailAuthBloc>().add(
                            EmailAuthOTPResendEvent(email: widget.email),
                          );

                          // Restart timer only when timer is finished
                          startTimer();
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
                      );
                    },
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
