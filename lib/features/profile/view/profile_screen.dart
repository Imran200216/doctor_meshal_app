import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
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
  @override
  void initState() {
    super.initState();

    // Load cached data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserAuthBloc>().add(LoadCachedUserAuthEvent());
    });
  }

  Future<void> _loadUserFromHiveAndFetch() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMap = await HiveService.getData<Map>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMap != null) {
        final storedUser = UserAuthModel.fromJson(
          Map<String, dynamic>.from(storedUserMap),
        );

        final connectivityState = context.read<ConnectivityBloc>().state;
        if (connectivityState is ConnectivitySuccess) {
          context.read<UserAuthBloc>().add(
            GetUserAuthEvent(id: storedUser.id, token: ""),
          );
        }
      }
    } catch (e) {
      AppLoggerHelper.logError("Error loading user from Hive: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: SafeArea(
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            return BlocBuilder<UserAuthBloc, UserAuthState>(
              builder: (context, state) {
                // Handle different states
                if (state is GetUserAuthLoading) {
                  // Check if we should show skeleton
                  final bloc = context.read<UserAuthBloc>();
                  if (bloc.getCachedUser() == null) {
                    return ProfileSkeleton();
                  }
                }

                if (state is GetUserAuthSuccess) {
                  final bool isOnline =
                      connectivityState is ConnectivitySuccess;
                  final bool isOffline =
                      connectivityState is ConnectivityFailure;

                  return RefreshIndicator.adaptive(
                    color: AppColorConstants.secondaryColor,
                    backgroundColor: AppColorConstants.primaryColor,
                    onRefresh: () async {
                      if (isOnline) {
                        await _loadUserFromHiveAndFetch();
                      }
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
                              // Profile Details
                              ProfileDetailsContainer(
                                profileImageUrl:
                                    state.user.profileImage.isNotEmpty
                                    ? state.user.profileImage
                                    : "https://e-quester.com/wp-content/uploads/2021/11/placeholder-image-person-jpg.jpg",
                                name:
                                    "${state.user.firstName} ${state.user.lastName}",
                                email: state.user.email,
                              ),

                              // Rest of your sections...
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

                if (state is GetUserAuthFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColorConstants.subTitleColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserFromHiveAndFetch,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Initial state
                return ProfileSkeleton();
              },
            );
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
                // Get userId from UserAuthBloc
                final userAuthBloc = context.read<UserAuthBloc>();
                final userId = userAuthBloc.getCachedUserId();

                if (userId == null || userId.isEmpty) {
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
                          EmailAuthLogoutEvent(userId: userId),
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
