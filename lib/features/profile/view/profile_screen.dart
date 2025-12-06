import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';
import 'package:meshal_doctor_booking_app/features/profile/profile.dart';

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
    // Fetch User Auth
    _fetchUserAuth();

    super.initState();
  }

  // Fetch User Auth
  Future<void> _fetchUserAuth() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Read full userAuthData from Hive (no generic type)
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Trigger EducationBloc to fetch data
        context.read<UserAuthBloc>().add(
          GetUserAuthEvent(id: userId!, token: ""),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
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

    // Placeholder Image
    final placeholderImage =
        "https://e-quester.com/wp-content/uploads/2021/11/placeholder-image-person-jpg.jpg";

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          color: AppColorConstants.secondaryColor,
          backgroundColor: AppColorConstants.primaryColor,
          onRefresh: () async {
            // Fetch User Auth
            _fetchUserAuth();
          },
          child: SingleChildScrollView(
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
                  BlocBuilder<UserAuthBloc, UserAuthState>(
                    builder: (context, state) {
                      // Loading
                      if (state is GetUserAuthLoading ||
                          state is UserAuthInitial) {
                        return KSkeletonRectangle(
                          height: isMobile
                              ? 150
                              : isTablet
                              ? 200
                              : 240,
                        );
                      }

                      // ONLINE or OFFLINE success → show data
                      if (state is GetUserAuthSuccess ||
                          state is GetUserAuthOfflineSuccess) {
                        final user = state is GetUserAuthSuccess
                            ? (state).user
                            : (state as GetUserAuthOfflineSuccess).user;

                        return ProfileDetailsContainer(
                          profileImageUrl: user.profileImage.isNotEmpty
                              ? user.profileImage
                              : placeholderImage,
                          name: "${user.firstName} ${user.lastName}",
                          email: user.email,
                        );
                      }

                      // Failure
                      if (state is GetUserAuthFailure) {
                        if (state.message.contains("No user data")) {
                          return Center(
                            child: Text(
                              "No cached user data. Connect to internet.",
                            ),
                          );
                        }
                        return Center(child: Text("Failed to load user"));
                      }

                      return SizedBox.shrink();
                    },
                  ),

                  // General Section
                  _buildGeneralSection(context, appLoc, isMobile, isTablet),

                  // Support Section
                  _buildSupportSection(context, appLoc, isMobile, isTablet),

                  // Logout Section
                  _buildLogoutSection(context, appLoc),
                ],
              ),
            ),
          ),
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
                  //  Profile Localization Screen
                  GoRouter.of(
                    context,
                  ).pushNamed(AppRouterConstants.profileLocalization);
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

              // Feedback
              BlocBuilder<UserAuthBloc, UserAuthState>(
                builder: (context, state) {
                  if (state is GetUserAuthSuccess) {
                    return ProfileListTile(
                      prefixIcon: Icons.feedback_outlined,
                      title: state.user.userType == "patient"
                          ? appLoc.writeFeedback
                          : appLoc.patientFeedbacks,
                      onTap: () {
                        // Screen
                        GoRouter.of(context).pushNamed(
                          state.user.userType == "patient"
                              ? AppRouterConstants.writeFeedback
                              : AppRouterConstants.viewDoctorFeedback,
                        );
                      },
                    );
                  }

                  return SizedBox();
                },
              ),
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
            listener: (context, state) async {
              // ✅ Make listener async
              if (state is EmailAuthLogoutSuccess) {
                if (state.status == true) {
                  // 🛑 STOP ALL ACTIVE SUBSCRIPTIONS FIRST
                  context.read<ViewUserChatHomeBloc>().add(
                    StopViewUserChatHomeSubscriptionEvent(),
                  );

                  // ✅ Clear Hive Boxes PROPERLY with await
                  try {
                    // Open boxes first if not already open
                    await HiveService.openBox(AppDBConstants.userBox);
                    await HiveService.openBox(AppDBConstants.surveyForm);
                    await HiveService.openBox(AppDBConstants.chatRoom);

                    AppLoggerHelper.logInfo(
                      "📦 All Hive boxes opened for clearing",
                    );

                    // Clear all boxes
                    await HiveService.clearBox(AppDBConstants.userBox);
                    await HiveService.clearBox(AppDBConstants.surveyForm);
                    await HiveService.clearBox(AppDBConstants.chatRoom);

                    AppLoggerHelper.logInfo(
                      "✅ All Hive boxes cleared successfully: "
                      "${AppDBConstants.userBox}, "
                      "${AppDBConstants.surveyForm}, "
                      "${AppDBConstants.chatRoom}",
                    );
                  } catch (e) {
                    AppLoggerHelper.logError(
                      "❌ Failed to clear Hive boxes: $e",
                    );
                  }

                  // Success Snack Bar
                  KSnackBar.success(context, appLoc.logoutSuccess);

                  // Navigate to Localization Screen
                  GoRouter.of(context).goNamed(AppRouterConstants.localization);

                  // Clear Language
                  context.read<LocalizationCubit>().clearLanguage();
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
                if (userId == null || userId!.isEmpty) {
                  KSnackBar.error(context, "User ID not found");
                  return;
                }

                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ProfileLogOutBottomSheet(
                      onCancelTap: () => GoRouter.of(context).pop(),
                      onSubmitLoading:
                          context.watch<EmailAuthBloc>().state
                              is EmailAuthLogoutLoading,
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
