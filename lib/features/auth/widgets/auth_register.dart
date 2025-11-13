import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_password_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_phone_number_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({super.key});

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Default
  String selectedPhoneCode = '+91';
  String phoneNumber = '';

  // Controller
  final TextEditingController authFirstNameRegisterController =
      TextEditingController();
  final TextEditingController authLastNameRegisterController =
      TextEditingController();
  final TextEditingController authEmailRegisterController =
      TextEditingController();
  final TextEditingController authPasswordRegisterController =
      TextEditingController();

  @override
  void dispose() {
    authFirstNameRegisterController.dispose();
    authLastNameRegisterController.dispose();
    authEmailRegisterController.dispose();
    authPasswordRegisterController.dispose();

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

    return Form(
      key: _formKey,
      child: Column(
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
            hintText: appLoc.enterPhoneNumber,
            labelText: appLoc.phoneNumber,
            locale: locale,
            onChanged: (value) {
              phoneNumber = value;
            },
            onCountryChanged: (code) {
              selectedPhoneCode = code;
            },
          ),

          // Password Text Form Field
          KPasswordTextFormField(
            controller: authPasswordRegisterController,
            hintText: appLoc.enterPassword,
            labelText: appLoc.password,
          ),

          const SizedBox(height: 30),

          // Register Btn
          BlocConsumer<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) async {
              if (state is EmailAuthSuccess) {
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

                // Clear Controllers
                authFirstNameRegisterController.clear();
                authLastNameRegisterController.clear();
                authEmailRegisterController.clear();
                authPasswordRegisterController.clear();
                phoneNumber = '';
                selectedPhoneCode = '+91';
              }
            },
            builder: (context, state) {
              return KFilledBtn(
                isLoading: state is EmailAuthLoading,
                btnTitle: appLoc.register,
                btnBgColor: AppColorConstants.primaryColor,
                btnTitleColor: AppColorConstants.secondaryColor,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Email Auth Register Event
                    context.read<EmailAuthBloc>().add(
                      EmailAuthRegisterEvent(
                        firstName: authFirstNameRegisterController.text.trim(),
                        lastName: authLastNameRegisterController.text.trim(),
                        email: authEmailRegisterController.text.trim(),
                        password: authPasswordRegisterController.text.trim(),
                        phoneCode: selectedPhoneCode,
                        phoneNumber: phoneNumber.trim(),
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
    );
  }
}
