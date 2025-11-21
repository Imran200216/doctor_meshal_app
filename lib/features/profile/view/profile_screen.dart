import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_internet_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_url_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/core/utils/url_launcher_helper.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/localization/view_model/cubit/localization_cubit.dart';
import 'package:meshal_doctor_booking_app/features/profile/widgets/profile_details_container.dart';
import 'package:meshal_doctor_booking_app/features/profile/widgets/profile_list_tile.dart';
import 'package:meshal_doctor_booking_app/features/profile/widgets/profile_localization_bottom_sheet.dart';
import 'package:meshal_doctor_booking_app/features/profile/widgets/profile_log_out_bottom_sheet.dart';
import 'package:meshal_doctor_booking_app/features/profile/widgets/profile_skeleton.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchUserAuth();

    super.initState();
  }

  // Fetch Education Articles
  Future<void> _fetchUserAuth() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Get User Details
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
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Person Placeholder Image
    const String personPlaceholder =
        "https://i.pinimg.com/736x/e1/e1/af/e1e1af3435004e297bc6067d2448f8e5.jpg";

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: SafeArea(
        top: true,
        bottom: true,
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityFailure) {
              return Align(
                alignment: Alignment.center,
                heightFactor: 3,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const KInternetFound()],
                ),
              );
            } else if (connectivityState is ConnectivitySuccess) {
              return BlocBuilder<UserAuthBloc, UserAuthState>(
                builder: (context, state) {
                  // Loading
                  if (state is GetUserAuthLoading || state is UserAuthInitial) {
                    return ProfileSkeleton();
                  }

                  // Success
                  if (state is GetUserAuthSuccess) {
                    final user = state.user;

                    return RefreshIndicator.adaptive(
                      color: AppColorConstants.secondaryColor,
                      backgroundColor: AppColorConstants.primaryColor,
                      onRefresh: () async {
                        _fetchUserAuth();
                      },
                      child: SingleChildScrollView(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
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
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // My Account
                                KText(
                                  text: appLoc.myAccount,
                                  fontSize: isMobile
                                      ? 20
                                      : isTablet
                                      ? 22
                                      : 24,
                                  fontWeight: FontWeight.w700,
                                ),

                                // Profile
                                ProfileDetailsContainer(
                                  profileImageUrl: user.profileImage.isNotEmpty
                                      ? user.profileImage
                                      : personPlaceholder,
                                  name: "${user.firstName} ${user.lastName}",
                                  email: user.email,
                                ),

                                // ---------- REST OF YOUR UI BELOW ----------
                                _buildGeneralSection(
                                  context,
                                  appLoc,
                                  isMobile,
                                  isTablet,
                                ),
                                _buildSupportSection(
                                  context,
                                  appLoc,
                                  isMobile,
                                  isTablet,
                                ),
                                _buildLogoutSection(context, appLoc),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  // General Section
  Widget _buildGeneralSection(
    BuildContext context,
    AppLocalizations appLoc,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        KText(
          text: appLoc.general,
          fontSize: isMobile
              ? 20
              : isTablet
              ? 22
              : 24,
          fontWeight: FontWeight.w700,
          color: AppColorConstants.titleColor,
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColorConstants.subTitleColor.withOpacity(0.05),
          ),
          child: Column(
            spacing: 10,
            children: [
              ProfileListTile(
                prefixIcon: Icons.notes_outlined,
                title: appLoc.personDetails,
                onTap: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRouterConstants.personalDetails);
                },
              ),

              ProfileListTile(
                prefixIcon: Icons.edit_outlined,
                title: appLoc.editProfile,
                onTap: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRouterConstants.editPersonalDetails);
                },
              ),

              ProfileListTile(
                prefixIcon: Icons.language_outlined,
                title: appLoc.language,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ProfileLocalizationBottomSheet(),
                  );
                },
              ),

              ProfileListTile(
                prefixIcon: Icons.password,
                title: appLoc.changePassword,
                onTap: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRouterConstants.changePassword);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Support Section
  Widget _buildSupportSection(
    BuildContext context,
    AppLocalizations appLoc,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        KText(
          text: appLoc.support,
          fontSize: isMobile
              ? 20
              : isTablet
              ? 22
              : 24,
          fontWeight: FontWeight.w700,
          color: AppColorConstants.titleColor,
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColorConstants.subTitleColor.withOpacity(0.05),
          ),
          child: Column(
            spacing: 10,
            children: [
              // ProfileListTile(
              //   prefixIcon: Icons.app_registration,
              //   title: appLoc.termsAndConditions,
              //   onTap: () {
              //     UrlLauncherHelper.launchUrlLink('https://flutter.dev');
              //   },
              // ),

              // Privacy Policy
              ProfileListTile(
                prefixIcon: Icons.privacy_tip_outlined,
                title: appLoc.privacyPolicy,
                onTap: () {
                  // Privacy Policy
                  UrlLauncherHelper.launchUrlLink(
                    AppUrlConstants.privacyPolicy,
                  );
                },
              ),

              // Support
            ],
          ),
        ),
      ],
    );
  }

  // Logout Section
  Widget _buildLogoutSection(BuildContext context, AppLocalizations appLoc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColorConstants.subTitleColor.withOpacity(0.05),
      ),
      child: Column(
        spacing: 10,
        children: [
          BlocListener<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) {
              if (state is EmailAuthLogoutSuccess) {
                if (state.status == true) {
                  // Success Snack Bar
                  KSnackBar.success(context, appLoc.logoutSuccess);

                  // Navigate to Localization Screen
                  GoRouter.of(context).goNamed(AppRouterConstants.localization);

                  // Clear Language
                  context.read<LocalizationCubit>().clearLanguage();

                  // Clear Hive Boxes
                  try {
                    HiveService.clearBox(AppDBConstants.userBox);
                    HiveService.clearBox(AppDBConstants.surveyForm);

                    AppLoggerHelper.logInfo(
                      "Hive Box Cleared: ${AppDBConstants.userBox}, ${AppDBConstants.surveyForm}",
                    );
                  } catch (e) {
                    AppLoggerHelper.logError(
                      "Failed to clear Hive Box userBox: $e",
                    );
                  }

                  try {
                    HiveService.clearBox(AppDBConstants.surveyForm);
                    AppLoggerHelper.logInfo(
                      "Hive Box Cleared: ${AppDBConstants.surveyForm}",
                    );
                  } catch (e) {
                    AppLoggerHelper.logError(
                      "Failed to clear Hive Box surveyForm: $e",
                    );
                  }
                } else {
                  // Failure Snack Bar
                  KSnackBar.error(context, appLoc.logoutFailed);
                }
              } else if (state is EmailAuthLogoutFailure) {
                // Failure Snack Bar
                KSnackBar.error(context, state.message);
              }
            },

            child: ProfileListTile(
              prefixIcon: Icons.logout,
              title: appLoc.logout,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ProfileLogOutBottomSheet(
                      onCancelTap: () => GoRouter.of(context).pop(),
                      onSubmitTap: () {
                        // Logout Functionality
                        context.read<EmailAuthBloc>().add(
                          EmailAuthLogoutEvent(userId: userId!),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
