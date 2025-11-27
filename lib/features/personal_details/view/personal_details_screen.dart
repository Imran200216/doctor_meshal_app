import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

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

  // Phone Number
  String? profileImage;

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
      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Fetch User Id Details
          _fetchUserIdAndDetails();
        },
        child: BlocBuilder<UserAuthBloc, UserAuthState>(
          builder: (context, state) {
            if (state is GetUserAuthLoading) {
              return ListView.separated(
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
                      ? 20
                      : isTablet
                      ? 30
                      : 40,
                ),
                itemCount: 30,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
                itemBuilder: (context, index) {
                  return KSkeletonTextFormField();
                },
              );
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
              profileImage = user.profileImage;
            }

            if (state is GetUserAuthFailure) {
              AppLoggerHelper.logError("Failed to load user: ${state.message}");
            }

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                      ? 100
                      : isTablet
                      ? 130
                      : 140,
                ),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        KText(
                          textAlign: TextAlign.start,
                          text: appLoc.profileImage,
                          fontSize: isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColorConstants.titleColor,
                        ),

                        KProfileAvatar(
                          personImageUrl: profileImage!,
                          width: isMobile
                              ? 90
                              : isTablet
                              ? 100
                              : 110,
                          height: isMobile
                              ? 90
                              : isTablet
                              ? 100
                              : 110,
                        ),
                      ],
                    ),

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
                      hintText: appLoc.enterCivilId,
                      labelText: appLoc.civilId,
                    ),

                    // Gender
                    KTextFormField(
                      readOnly: true,
                      controller: genderController,
                      hintText: appLoc.enterGender,
                      labelText: appLoc.gender,
                    ),

                    // Age
                    KDatePickerTextFormField(
                      readOnly: true,
                      controller: dobController,
                      labelText: appLoc.dateOfBirth,
                      hintText: appLoc.dateOfBirth,
                    ),

                    // Register Date
                    KDatePickerTextFormField(
                      readOnly: true,
                      controller: registerDateController,
                      labelText: appLoc.registerDate,
                      hintText: appLoc.selectDate,
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
                      hintText: appLoc.enterBloodGroup,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
