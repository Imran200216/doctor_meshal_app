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

  // Controllers
  final TextEditingController _authFirstNameRegisterController =
      TextEditingController();
  final TextEditingController _authLastNameRegisterController =
      TextEditingController();
  final TextEditingController _authEmailRegisterController =
      TextEditingController();
  final TextEditingController _authPasswordRegisterController =
      TextEditingController();

  @override
  void dispose() {
    _authFirstNameRegisterController.dispose();
    _authLastNameRegisterController.dispose();
    _authEmailRegisterController.dispose();
    _authPasswordRegisterController.dispose();

    super.dispose();
  }

  // Clear All Controllers
  void clearAllController() {
    _authFirstNameRegisterController.clear();
    _authLastNameRegisterController.clear();
    _authEmailRegisterController.clear();
    _authPasswordRegisterController.clear();
    phoneNumber = '';
    selectedPhoneCode = '+91';
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
            controller: _authFirstNameRegisterController,
            hintText: appLoc.enterFirstName,
            labelText: appLoc.firstName,
            autofillHints: [
              AutofillHints.name,
              AutofillHints.namePrefix,
              AutofillHints.nameSuffix,
            ],
            validator: (value) => AppValidators.lastName(context, value),
          ),

          // Last Name Text Form Field
          KTextFormField(
            controller: _authLastNameRegisterController,
            hintText: appLoc.enterLastName,
            labelText: appLoc.lastName,
            autofillHints: [
              AutofillHints.name,
              AutofillHints.namePrefix,
              AutofillHints.nameSuffix,
            ],
            validator: (value) => AppValidators.lastName(context, value),
          ),

          // Email Text Form Field
          KTextFormField(
            controller: _authEmailRegisterController,
            hintText: appLoc.enterEmail,
            labelText: appLoc.email,
            autofillHints: [AutofillHints.email],
            validator: (value) => AppValidators.email(context, value),
          ),

          // Phone Number Text Form Field
          KPhoneNumberTextFormField(
            hintText: appLoc.enterPhoneNumber,
            labelText: appLoc.phoneNumber,
            validator: (value) => AppValidators.phoneNumber(context, value),
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
            controller: _authPasswordRegisterController,
            hintText: appLoc.enterPassword,
            labelText: appLoc.password,
            validator: (value) => AppValidators.password(context, value),
          ),

          const SizedBox(height: 30),

          // Register Btn
          BlocConsumer<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) async {
              if (state is EmailAuthSuccess) {
                try {
                  // Open Hive box
                  await HiveService.openBox(AppDBConstants.userBox);

                  // Create full UserAuthModel
                  final userModel = UserAuthModel(
                    id: state.id,
                    profileImage: "",
                    firstName: _authFirstNameRegisterController.text.trim(),
                    lastName: _authLastNameRegisterController.text.trim(),
                    email: _authEmailRegisterController.text.trim(),
                    phoneCode: selectedPhoneCode,
                    phoneNumber: phoneNumber.trim(),
                    registerDate: DateTime.now().toString(),
                    age: "",
                    gender: "",
                    height: "",
                    weight: "",
                    bloodGroup: "",
                    cid: "",
                    createdAt: DateTime.now().toString(),
                    updatedAt: DateTime.now().toString(),
                    userType: "patient",
                  );

                  // Save full model in Hive
                  await HiveService.saveData(
                    boxName: AppDBConstants.userBox,
                    key: AppDBConstants.userAuthData,
                    value: userModel.toJson(),
                  );

                  AppLoggerHelper.logInfo(
                    "UserAuthModel successfully saved in Hive => $userModel",
                  );

                  await HiveService.saveData(
                    boxName: AppDBConstants.userBox,
                    key: AppDBConstants.userAuthLoggedStatus,
                    value: true,
                  );
                  AppLoggerHelper.logInfo(
                    "User Logged Status saved successfully in Hive",
                  );
                } catch (e) {
                  AppLoggerHelper.logError(
                    "Error saving UserAuthModel in Hive: $e",
                  );
                }

                // Show success
                KSnackBar.success(context, "Registration Success");

                // Navigate
                Future.delayed(const Duration(milliseconds: 400), () {
                  GoRouter.of(
                    context,
                  ).pushReplacementNamed(AppRouterConstants.patientBottomNav);
                });

                clearAllController();
              }

              if (state is EmailAuthError) {
                Future.microtask(() {
                  KSnackBar.error(context, state.message);
                });
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
                    final connectivityState = context
                        .read<ConnectivityBloc>()
                        .state;

                    // Correct internet check
                    if (connectivityState is ConnectivityFailure ||
                        (connectivityState is ConnectivitySuccess &&
                            connectivityState.isConnected == false)) {
                      Future.microtask(() {
                        KSnackBar.error(context, appLoc.internetConnection);
                      });
                      return;
                    }

                    // Fire Register Event
                    context.read<EmailAuthBloc>().add(
                      EmailAuthRegisterEvent(
                        firstName: _authFirstNameRegisterController.text.trim(),
                        lastName: _authLastNameRegisterController.text.trim(),
                        email: _authEmailRegisterController.text.trim(),
                        password: _authPasswordRegisterController.text.trim(),
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
