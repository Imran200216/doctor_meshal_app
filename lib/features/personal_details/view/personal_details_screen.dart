import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_date_picker_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // User Id
  String? userId;

  // Phone Code
  String? phoneCode;

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController registerDateController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController civilIdController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    registerDateController.dispose();
    dobController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodGroupController.dispose();
    civilIdController.dispose();

    phoneCode = "+91";

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndDetails();
  }

  // Fetch User Id Details
  Future<void> _fetchUserIdAndDetails() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);
      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Dispatch the event to get user details
        context.read<UserAuthBloc>().add(
          GetUserAuthEvent(id: userId!, token: ""),
        );
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.personDetails,
        onBack: () => GoRouter.of(context).pop(),
      ),
      body: BlocBuilder<UserAuthBloc, UserAuthState>(
        builder: (context, state) {
          if (state is GetUserAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetUserAuthSuccess) {
            final user = state.user;

            // Populate controllers
            firstNameController.text = user.firstName;
            lastNameController.text = user.lastName;
            emailController.text = user.email;
            phoneNumberController.text = user.phoneNumber;
            dobController.text = user.age;
            genderController.text = user.gender;
            registerDateController.text = user.registerDate;
            heightController.text = user.height;
            weightController.text = user.weight;
            bloodGroupController.text = user.bloodGroup;
            civilIdController.text = user.cid;
            phoneCode = user.phoneCode;
          }

          if (state is GetUserAuthFailure) {
            AppLoggerHelper.logError("Failed to load user: ${state.message}");
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                left: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
                right: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
                top: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
                bottom: isMobile
                    ? 200
                    : isTablet
                    ? 220
                    : 240,
              ),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name
                  KTextFormField(
                    readOnly: true,
                    controller: firstNameController,
                    hintText: appLoc.enterFirstName,
                    labelText: appLoc.firstName,
                  ),

                  // Last Name
                  KTextFormField(
                    readOnly: true,
                    controller: lastNameController,
                    hintText: appLoc.enterLastName,
                    labelText: appLoc.lastName,
                  ),

                  // Email
                  KTextFormField(
                    readOnly: true,
                    controller: emailController,
                    hintText: appLoc.enterEmail,
                    labelText: appLoc.email,
                  ),

                  // Phone Number
                  KTextFormField(
                    readOnly: true,
                    hintText: appLoc.enterPhoneNumber,
                    controller: phoneNumberController,
                    labelText: appLoc.phoneNumber,
                  ),

                  // Civil Id
                  KTextFormField(
                    readOnly: true,
                    controller: civilIdController,
                    hintText: "Enter Civil ID",
                    labelText: "Civil Id",
                  ),

                  // Gender
                  KTextFormField(
                    readOnly: true,
                    controller: genderController,
                    hintText: "Enter Gender",
                    labelText: "Gender",
                  ),

                  // Age
                  KDatePickerTextFormField(
                    readOnly: true,
                    controller: dobController,
                    labelText: "Age",
                    hintText: "Age",
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please select a date"
                        : null,
                  ),

                  // Register Date
                  KDatePickerTextFormField(
                    readOnly: true,
                    controller: registerDateController,
                    labelText: appLoc.dateOfBirth,
                    hintText: appLoc.selectDate,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please select a date"
                        : null,
                  ),

                  // Height
                  KTextFormField(
                    readOnly: true,
                    controller: heightController,
                    labelText: appLoc.height,
                    hintText: appLoc.enterHeight,
                    keyboardType: TextInputType.number,
                  ),

                  // Weight
                  KTextFormField(
                    readOnly: true,
                    controller: weightController,
                    labelText: appLoc.weight,
                    hintText: appLoc.enterWeight,
                    keyboardType: TextInputType.number,
                  ),

                  // Blood Group
                  KTextFormField(
                    readOnly: true,
                    controller: bloodGroupController,
                    labelText: appLoc.bloodGroup,
                    hintText: appLoc.selectBloodGroup,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
