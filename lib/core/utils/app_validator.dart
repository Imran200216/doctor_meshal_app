import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AppValidators {
  static String? email(BuildContext context, String? value) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.emailEmpty;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return appLoc.emailInvalid;
    }

    return null;
  }

  static String? password(BuildContext context, String? value) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.passwordEmpty;
    }
    return null;
  }

  static String? firstName(BuildContext context, String? value) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.firstNameEmpty;
    }
    return null;
  }

  static String? lastName(BuildContext context, String? value) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.lastNameEmpty;
    }
    return null;
  }

  static String? phoneNumber(BuildContext context, String? value) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.phoneNumberEmpty;
    }
    return null;
  }

  static String? confirmPassword(
      BuildContext context,
      String? value,
      String newPassword,
      ) {
    final appLoc = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return appLoc.confirmPasswordEmpty;
    }

    if (value.trim() != newPassword.trim()) {
      return appLoc.passwordsDoNotMatch;
    }

    return null;
  }

  static String? empty(
      BuildContext context,
      String? value,
      String errorMessage,
      ) {
    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }

}
