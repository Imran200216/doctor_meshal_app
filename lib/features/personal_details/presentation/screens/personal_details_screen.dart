import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_date_picker_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_drop_down_text_form_field.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_outlined_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_form_field.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();

  //  Dropdown Flags
  String? selectedGender;
  String? selectedBloodGroup;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    bloodGroupController.dispose();

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
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: isMobile
            ? 180
            : isTablet
            ? 220
            : 240,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColorConstants.secondaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppColorConstants.subTitleColor.withOpacity(0.2),
          ),
        ),
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cancel
              KOutlinedBtn(
                btnTitle: appLoc.cancel,
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

              // Add Personal Details Btn
              KFilledBtn(
                btnTitle: appLoc.addPersonalDetails,
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
          ),
        ),
      ),
      appBar: KAppBar(
        title: appLoc.personDetails,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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

            bottom: isMobile
                ? 200
                : isTablet
                ? 220
                : 240,
            top: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
          ),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // First Name Text Form Field
              KTextFormField(
                controller: firstNameController,
                hintText: appLoc.enterFirstName,
                labelText: appLoc.firstName,
                autofillHints: [
                  AutofillHints.familyName,
                  AutofillHints.givenName,
                  AutofillHints.namePrefix,
                  AutofillHints.nameSuffix,
                ],
              ),

              // Last Name Text Form Field
              KTextFormField(
                controller: lastNameController,
                hintText: appLoc.enterLastName,
                labelText: appLoc.lastName,
                autofillHints: [
                  AutofillHints.familyName,
                  AutofillHints.givenName,
                  AutofillHints.namePrefix,
                  AutofillHints.nameSuffix,
                ],
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

              // Date Picker Text Form Field
              KDatePickerTextFormField(
                labelText: appLoc.dateOfBirth,
                hintText: appLoc.selectDate,
                controller: dobController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a date";
                  }
                  return null;
                },
              ),

              // Height Text Form Field
              KTextFormField(
                controller: heightController,
                labelText: appLoc.height,
                hintText: appLoc.enterHeight,
                keyboardType: TextInputType.number,
              ),

              // Weight Text Form Field
              KTextFormField(
                controller: weightController,
                labelText: appLoc.weight,
                hintText: appLoc.enterWeight,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
