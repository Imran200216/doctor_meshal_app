import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_date_picker_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_drop_down_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/model/update_user_profile_details_model.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view_model/bloc/update_user_profile_details_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class EditPersonalDetailsScreen extends StatefulWidget {
  const EditPersonalDetailsScreen({super.key});

  @override
  State<EditPersonalDetailsScreen> createState() =>
      _EditPersonalDetailsScreenState();
}

class _EditPersonalDetailsScreenState extends State<EditPersonalDetailsScreen> {
  // User Id
  String? userId;

  //  Dropdown Flags
  String? selectedGender;
  String? selectedBloodGroup;

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    _fetchUserIdAndDetails();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();

    super.dispose();
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
        title: appLoc.editProfile,
        onBack: () => GoRouter.of(context).pop(),
      ),
      body: BlocBuilder<UserAuthBloc, UserAuthState>(
        builder: (context, state) {
          if (state is GetUserAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetUserAuthSuccess) {
            final user = state.user;

            firstNameController.text = user.firstName;
            lastNameController.text = user.lastName;
            dobController.text = user.age;
            heightController.text = user.height;
            weightController.text = user.weight;

            // Check if the value exists in the dropdown options
            selectedGender =
                [appLoc.male, appLoc.female, appLoc.other].contains(user.gender)
                ? user.gender
                : null;

            selectedBloodGroup =
                [
                  "A+",
                  "A-",
                  "B+",
                  "B-",
                  "AB+",
                  "AB-",
                  "O+",
                  "O-",
                ].contains(user.bloodGroup)
                ? user.bloodGroup
                : null;
          }

          if (state is GetUserAuthFailure) {
            AppLoggerHelper.logError("Failed to load user: ${state.message}");
          }

          return SingleChildScrollView(
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
                    ? 80
                    : isTablet
                    ? 100
                    : 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 20,
                children: [
                  // First Name
                  KTextFormField(
                    controller: firstNameController,
                    hintText: appLoc.enterFirstName,
                    labelText: appLoc.firstName,
                  ),

                  // Last Name
                  KTextFormField(
                    controller: lastNameController,
                    hintText: appLoc.enterLastName,
                    labelText: appLoc.lastName,
                  ),

                  // Date of Birth
                  KDatePickerTextFormField(
                    controller: dobController,
                    labelText: appLoc.dateOfBirth,
                    hintText: appLoc.selectDate,
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Please select a date"
                        : null,
                  ),

                  // Gender Drop Down Text Form Field
                  KDropDownTextFormField(
                    hintText: appLoc.selectGender,
                    labelText: appLoc.gender,
                    value: selectedGender,
                    items: [
                      DropdownMenuItem(
                        value: appLoc.male,
                        child: Text(appLoc.male),
                      ),
                      DropdownMenuItem(
                        value: appLoc.female,
                        child: Text(appLoc.female),
                      ),
                      DropdownMenuItem(
                        value: appLoc.other,
                        child: Text(appLoc.other),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),

                  // Height
                  KTextFormField(
                    controller: heightController,
                    labelText: appLoc.height,
                    hintText: appLoc.enterHeight,
                    keyboardType: TextInputType.number,
                  ),

                  // Weight
                  KTextFormField(
                    controller: weightController,
                    labelText: appLoc.weight,
                    hintText: appLoc.enterWeight,
                    keyboardType: TextInputType.number,
                  ),

                  // Blood Group Drop Down Text Form Field
                  KDropDownTextFormField(
                    hintText: appLoc.selectBloodGroup,
                    labelText: appLoc.bloodGroup,
                    value: selectedBloodGroup,
                    items: const [
                      DropdownMenuItem(value: "A+", child: Text("A+")),
                      DropdownMenuItem(value: "A-", child: Text("A-")),
                      DropdownMenuItem(value: "B+", child: Text("B+")),
                      DropdownMenuItem(value: "B-", child: Text("B-")),
                      DropdownMenuItem(value: "AB+", child: Text("AB+")),
                      DropdownMenuItem(value: "AB-", child: Text("AB-")),
                      DropdownMenuItem(value: "O+", child: Text("O+")),
                      DropdownMenuItem(value: "O-", child: Text("O-")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedBloodGroup = value;
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  BlocConsumer<
                    UpdateUserProfileDetailsBloc,
                    UpdateUserProfileDetailsState
                  >(
                    listener: (context, state) {
                      if (state is UpdateUserProfileDetailsSuccess) {
                        // Show success toast
                        KSnackBar.success(
                          context,
                          "Updated Profile Successfully",
                        );

                        // Go Back
                        GoRouter.of(context).pop();
                      }

                      if (state is UpdateUserProfileDetailsFailure) {
                        // Show error toast
                        KSnackBar.error(context, "Update Profile Failed");
                      }
                    },
                    builder: (context, state) {
                      return KFilledBtn(
                        isLoading: state is UpdateUserProfileDetailsLoading,
                        btnTitle: appLoc.backToLogin,
                        btnBgColor: AppColorConstants.primaryColor,
                        btnTitleColor: AppColorConstants.secondaryColor,
                        onTap: () {
                          // Update User Profile Details Form Event
                          context.read<UpdateUserProfileDetailsBloc>().add(
                            UpdateUserProfileDetailsFormEvent(
                              model: UpdateUserProfileDetailsModel(
                                fistName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                age: dobController.text.trim(),
                                gender: selectedGender ?? "",
                                height: heightController.text.trim(),
                                weight: weightController.text.trim(),
                                bloodGroup: selectedBloodGroup ?? "",
                                userId: userId!,
                              ),
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
          );
        },
      ),
    );
  }
}
