import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // User Id
  String? userId;

  String? _lastSavedChatRoomId;

  StreamSubscription? _chatSubscription;

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
        _initializeUserAndChat(),
      ]);

      AppLoggerHelper.logInfo("All data fetched successfully!");
    } catch (e) {
      AppLoggerHelper.logError("Error fetching data: $e");
    }
  }

  // Fetch User Auth
  Future<void> _fetchUserAuth() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // SAFE conversion
        final Map<String, dynamic> storedUserMap = Map<String, dynamic>.from(
          storedUserMapRaw as Map,
        );

        // Convert to model
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Trigger Bloc
        context.read<UserAuthBloc>().add(
          GetUserAuthEvent(id: userId!, token: ""),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData: $e");
    }
  }

  // Fetch Doctor Dashboard Summary Counts
  Future<void> _fetchDoctorDashboardSummaryCounts() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Read userAuthData from Hive safely
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Parse model
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Dispatch event
        context.read<DoctorDashboardSummaryCountsBloc>().add(
          GetDoctorDashboardSummaryCountsEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData: $e");
    }
  }

  // View User Chat Room using userAuthData
  Future<void> _viewUserChatRoom() async {
    try {
      // Open Hive box
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

        // Dispatch event to get view user chat room
        context.read<ViewUserChatRoomBloc>().add(
          GetViewChatRoomEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData: $e");
    }
  }

  // Initialize User and Chat using userAuthData
  Future<void> _initializeUserAndChat() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Read full userAuthData from Hive (no generic type)
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null && mounted) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo(
          '👤 User ID fetched from userAuthData: $userId',
        );

        // Dispatch initial event
        context.read<ViewUserChatHomeBloc>().add(
          GetViewUserChatHomeEvent(userId: userId!),
        );

        // Listen for state changes to handle subscription
        _chatSubscription = context.read<ViewUserChatHomeBloc>().stream.listen((
          state,
        ) {
          AppLoggerHelper.logInfo('📡 Chat Bloc State: ${state.runtimeType}');
        });
      } else {
        AppLoggerHelper.logError('❌ No userAuthData found in Hive');
      }
    } catch (e) {
      AppLoggerHelper.logError('💥 Error initializing chat: $e');
    }
  }

  // Save Chat Room Id Hive
  Future<void> _saveChatRoomIdToHive(String chatRoomId) async {
    // Prevent saving the same ID multiple times
    if (_lastSavedChatRoomId == chatRoomId) return;

    try {
      AppLoggerHelper.logInfo(
        "📦 Opening Hive box: ${AppDBConstants.chatRoom}",
      );

      await HiveService.openBox(AppDBConstants.chatRoom);

      await HiveService.saveData(
        boxName: AppDBConstants.chatRoom,
        key: AppDBConstants.chatRoomSenderRoomId,
        value: chatRoomId,
      );

      _lastSavedChatRoomId = chatRoomId;

      AppLoggerHelper.logInfo(
        "✅ Hive Save Success → box: ${AppDBConstants.chatRoom}, "
        "key: ${AppDBConstants.chatRoomSenderRoomId}, "
        "value: $chatRoomId",
      );
    } catch (e) {
      AppLoggerHelper.logError("❌ Hive Save Failed → Error: $e");
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

                if (state is GetViewUserHomeChatRoomSuccess) {
                  count = int.tryParse(state.notificationCount) ?? 0;

                  _saveChatRoomIdToHive(state.id);
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
                      Badge.count(count: count, isLabelVisible: true),
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
