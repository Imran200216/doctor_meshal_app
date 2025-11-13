import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_password_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view_model/bloc/change_password/change_password_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
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
      appBar: KAppBar(
        title: appLoc.changePassword,
        onBack: () {
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

                // Old Password Text Form Field
                KPasswordTextFormField(
                  controller: oldPasswordController,
                  hintText: appLoc.enterOldPassword,
                  labelText: appLoc.oldPassword,
                ),

                const SizedBox(height: 20),

                // New Password Text Form Field
                KPasswordTextFormField(
                  controller: newPasswordController,
                  hintText: appLoc.enterNewPassword,
                  labelText: appLoc.newPassword,
                ),

                const SizedBox(height: 20),

                // Confirm Password Text Form Field
                KPasswordTextFormField(
                  controller: confirmPasswordController,
                  hintText: appLoc.enterConfirmPassword,
                  labelText: appLoc.confirmPassword,
                ),

                const SizedBox(height: 50),

                // Change Password Btn
                BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                  listener: (context, state) {
                    if (state is ChangePasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password Changed Successfully"),
                        ),
                      );

                      // Go Back
                      GoRouter.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    return KFilledBtn(
                      isLoading: state is ChangePasswordLoading,
                      btnTitle: appLoc.changePassword,
                      btnBgColor: AppColorConstants.primaryColor,
                      btnTitleColor: AppColorConstants.secondaryColor,
                      onTap: () async {
                        // Open the Hive box if not already opened
                        await HiveService.openBox(AppDBConstants.userBox);

                        // Read userId from Hive
                        final storedUserId = await HiveService.getData<String>(
                          boxName: AppDBConstants.userBox,
                          key: AppDBConstants.userId,
                        );

                        AppLoggerHelper.logInfo(
                          "The Change Password user Id: $storedUserId",
                        );

                        context.read<ChangePasswordBloc>().add(
                          ChangePasswordUserEvent(
                            storedUserId!,
                            oldPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                            confirmPasswordController.text.trim(),
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
      ),
    );
  }
}
