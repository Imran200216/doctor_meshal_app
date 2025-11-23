import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_floating_action_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_greeting_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/doctor_dashboard_summary_counts/doctor_dashboard_summary_counts_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/user_chat_room/view_user_chat_room_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/widgets/doctor_dashboard_operative_form_counts.dart';
import 'package:meshal_doctor_booking_app/features/home/widgets/home_skeleton.dart';
import 'package:meshal_doctor_booking_app/features/home/widgets/peri_operative_score_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  // Fetch all data
  Future<void> _fetchAllData() async {
    try {
      // Run all futures in parallel
      await Future.wait([
        _fetchUserAuth(),
        _viewUserChatRoom(),
        _fetchDoctorDashboardSummaryCounts(),
      ]);

      AppLoggerHelper.logInfo("All data fetched successfully!");
    } catch (e) {
      AppLoggerHelper.logError("Error fetching data: $e");
    }
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

  // Fetch Doctor Dashboard Summary Counts
  Future<void> _fetchDoctorDashboardSummaryCounts() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Get Doctor Dashboard Summary Counts
        context.read<DoctorDashboardSummaryCountsBloc>().add(
          GetDoctorDashboardSummaryCountsEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID: $e");
    }
  }

  // View User Chat Room
  Future<void> _viewUserChatRoom() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Get View User Chat Room
        context.read<ViewUserChatRoomBloc>().add(
          GetViewChatRoomEvent(userId: userId!),
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

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        floatingActionButton:
            BlocBuilder<ViewUserChatRoomBloc, ViewUserChatRoomState>(
              builder: (context, state) {
                int count = 0;

                if (state is GetViewUserChatRoomSuccess) {
                  try {
                    count = int.tryParse(state.notificationCount) ?? 0;

                    /// Log before opening Hive box
                    AppLoggerHelper.logInfo(
                      "Opening Hive box: ${AppDBConstants.chatRoom}",
                    );

                    HiveService.openBox(AppDBConstants.chatRoom);

                    /// Save Data to Hive
                    HiveService.saveData(
                      boxName: AppDBConstants.chatRoom,
                      key: AppDBConstants.chatRoomSenderRoomId,
                      value: state.id,
                    );

                    /// Log success
                    AppLoggerHelper.logInfo(
                      "Hive Save Success → box: ${AppDBConstants.chatRoom}, "
                      "key: ${AppDBConstants.chatRoomSenderRoomId}, "
                      "value: ${state.id}",
                    );
                  } catch (e) {
                    /// Log error
                    AppLoggerHelper.logError("Hive Save Failed → Error: $e");
                  }
                }

                return FittedBox(
                  child: Stack(
                    alignment: const Alignment(1.4, -1.5),
                    children: [
                      KFloatingActionBtn(
                        onTap: () {
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRouterConstants.chatList);
                        },
                        fabIconPath: AppAssetsConstants.chats,
                        heroTag: "doctorList",
                      ),

                      // Show badge only when count > 0
                      Badge.count(count: count, isLabelVisible: count > 0),
                    ],
                  ),
                );
              },
            ),

        body: SafeArea(
          child: RefreshIndicator.adaptive(
            color: AppColorConstants.secondaryColor,
            backgroundColor: AppColorConstants.primaryColor,
            onRefresh: () async {
              _fetchAllData();
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // USER HEADER
                    BlocBuilder<UserAuthBloc, UserAuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER CONTAINER
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColorConstants.primaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        textAlign: TextAlign.start,
                                        text: "${getGreetingMessage(appLoc)},",
                                        fontSize: isMobile
                                            ? 22
                                            : isTablet
                                            ? 24
                                            : 26,
                                        fontWeight: FontWeight.w700,
                                        color: AppColorConstants.secondaryColor,
                                      ),
                                      const SizedBox(height: 5),

                                      if (state is GetUserAuthSuccess)
                                        KText(
                                          textAlign: TextAlign.start,
                                          text:
                                              "${state.user.firstName} ${state.user.lastName}",
                                          fontSize: isMobile
                                              ? 20
                                              : isTablet
                                              ? 22
                                              : 24,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              AppColorConstants.secondaryColor,
                                        ),
                                    ],
                                  ),

                                  Image.asset(
                                    AppAssetsConstants.doctorIntro,
                                    height: isMobile
                                        ? 160
                                        : isTablet
                                        ? 160
                                        : 180,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        );
                      },
                    ),

                    // Doctor Dashboard SUMMARY COUNTS
                    BlocBuilder<
                      DoctorDashboardSummaryCountsBloc,
                      DoctorDashboardSummaryCountsState
                    >(
                      builder: (context, state) {
                        if (state is GetDashboardSummaryCountsLoading) {
                          return HomeSkeleton();
                        }

                        if (state is GetDashboardSummaryCountsSuccess) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                textAlign: TextAlign.start,
                                text: appLoc.dashboardSummary,
                                fontSize: isMobile
                                    ? 20
                                    : isTablet
                                    ? 22
                                    : 24,
                                fontWeight: FontWeight.w700,
                                color: AppColorConstants.titleColor,
                              ),

                              const SizedBox(height: 20),

                              PeriOperativeScoreCard(
                                totalCount: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .totalPatient
                                    .toString(),
                                scoreCardTitle: appLoc.totalPatient,
                                icon: Icons.person,
                              ),

                              const SizedBox(height: 15),

                              PeriOperativeScoreCard(
                                totalCount: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .totalEducationArticles
                                    .toString(),
                                scoreCardTitle: appLoc.totalEducationArticles,
                                icon: Icons.school,
                              ),

                              const SizedBox(height: 30),

                              KText(
                                textAlign: TextAlign.start,
                                text: appLoc.operativeSummary,
                                fontSize: isMobile
                                    ? 20
                                    : isTablet
                                    ? 22
                                    : 24,
                                fontWeight: FontWeight.w700,
                                color: AppColorConstants.titleColor,
                              ),

                              const SizedBox(height: 20),

                              // Post Operative
                              DoctorDashboardOperativeFormCounts(
                                formName: "Post Operative",
                                submittedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative!
                                    .submitted
                                    .toString(),
                                reSubmittedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative!
                                    .resubmitted
                                    .toString(),
                                reviewedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative!
                                    .reviewed
                                    .toString(),
                                approvedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative!
                                    .approved
                                    .toString(),
                                rejectedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative!
                                    .rejected
                                    .toString(),
                              ),

                              const SizedBox(height: 20),

                              // Pre Operative
                              DoctorDashboardOperativeFormCounts(
                                formName: "Pre Operative",
                                submittedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative!
                                    .submitted
                                    .toString(),
                                reSubmittedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative!
                                    .resubmitted
                                    .toString(),
                                reviewedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative!
                                    .reviewed
                                    .toString(),
                                approvedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative!
                                    .approved
                                    .toString(),
                                rejectedCounts: state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative!
                                    .rejected
                                    .toString(),
                              ),
                            ],
                          );
                        }

                        if (state is GetDashboardSummaryCountsFailure) {
                          AppLoggerHelper.logError(state.message);
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
