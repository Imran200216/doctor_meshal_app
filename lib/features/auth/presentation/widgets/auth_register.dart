import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_password_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_phone_number_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({super.key});

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  // Controller
  final TextEditingController authFirstNameRegisterController =
      TextEditingController();
  final TextEditingController authLastNameRegisterController =
      TextEditingController();
  final TextEditingController authEmailRegisterController =
      TextEditingController();
  final TextEditingController authPasswordRegisterController =
      TextEditingController();
  final TextEditingController authPhoneNumberRegisterController =
      TextEditingController();

  @override
  void dispose() {
    authFirstNameRegisterController.dispose();
    authLastNameRegisterController.dispose();
    authEmailRegisterController.dispose();
    authPasswordRegisterController.dispose();
    authPhoneNumberRegisterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // First Name Text Form Field
        KTextFormField(
          controller: authFirstNameRegisterController,
          hintText: appLoc.enterFirstName,
          labelText: appLoc.firstName,
          autofillHints: [
            AutofillHints.name,
            AutofillHints.namePrefix,
            AutofillHints.nameSuffix,
          ],
        ),

        // Last Name Text Form Field
        KTextFormField(
          controller: authLastNameRegisterController,
          hintText: appLoc.enterLastName,
          labelText: appLoc.lastName,
          autofillHints: [
            AutofillHints.name,
            AutofillHints.namePrefix,
            AutofillHints.nameSuffix,
          ],
        ),

        // Email Text Form Field
        KTextFormField(
          controller: authEmailRegisterController,
          hintText: appLoc.enterEmail,
          labelText: appLoc.email,
          autofillHints: [AutofillHints.email],
        ),

        // Phone Number Text Form Field
        KPhoneNumberTextFormField(
          controller: authPhoneNumberRegisterController,
          hintText: appLoc.enterPhoneNumber,
          labelText: appLoc.phoneNumber,
          locale: locale,
        ),

        // Password Text Form Field
        KPasswordTextFormField(
          controller: authPasswordRegisterController,
          hintText: appLoc.enterPassword,
          labelText: appLoc.password,
        ),

        // Confirm Password Text Form Field
        KPasswordTextFormField(
          controller: authPasswordRegisterController,
          hintText: appLoc.enterConfirmPassword,
          labelText: appLoc.confirmPassword,
        ),

        const SizedBox(height: 30),

        // Register Btn
        KFilledBtn(
          btnTitle: appLoc.register,
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
      ],
    );
  }
}
