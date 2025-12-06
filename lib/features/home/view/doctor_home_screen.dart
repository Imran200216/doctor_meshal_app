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
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  // User Id
  String? userId;

  StreamSubscription? _chatSubscription;

  @override
  void initState() {
    super.initState();

    // Fetch User Auth
    _fetchUserAuth();

    // Fetch All DAta
    _fetchAllData();
  }

  // Fetch all data
  Future<void> _fetchAllData() async {
    try {
      // Run all futures in parallel
      await Future.wait([
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

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,

        // App Bar
        appBar: AppBar(
          backgroundColor: AppColorConstants.primaryColor,
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  // Open Drawer
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu, color: AppColorConstants.secondaryColor),
              );
            },
          ),
          title: Text(appLoc.meshalApp),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isMobile
                ? 20
                : isTablet
                ? 22
                : 24,
            color: AppColorConstants.secondaryColor,
            fontFamily: "OpenSans",
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(AppRouterConstants.notification);
              },
              icon:
                  BlocBuilder<
                    ViewNotificationUnReadCountBloc,
                    ViewNotificationUnReadCountState
                  >(
                    builder: (context, state) {
                      // 1️⃣ Only Loaded → Show count with badge
                      if (state is ViewNotificationUnReadCountLoaded) {
                        return Badge(
                          backgroundColor:
                              AppColorConstants.notificationBgColor,
                          label: Text(
                            state.unreadNotificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          child: Icon(
                            Icons.notifications,
                            color: AppColorConstants.secondaryColor,
                          ),
                        );
                      }

                      // 2️⃣ Initial or Failure → Show only notification icon
                      return Icon(
                        Icons.notifications,
                        color: AppColorConstants.secondaryColor,
                      );
                    },
                  ),
            ),
          ],
        ),

        // Drawer
        drawer: HomeDrawer(),

        // FAB
        floatingActionButton:
            BlocBuilder<ViewUserChatRoomBloc, ViewUserChatRoomState>(
              builder: (context, state) {
                int count = 0;

                if (state is GetViewUserHomeChatRoomSuccess) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER CONTAINER
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColorConstants.primaryColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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

                                  BlocBuilder<UserAuthBloc, UserAuthState>(
                                    builder: (context, state) {
                                      if (state is GetUserAuthSuccess ||
                                          state is GetUserAuthOfflineSuccess) {
                                        final user = state is GetUserAuthSuccess
                                            ? (state).user
                                            : (state as GetUserAuthOfflineSuccess)
                                                  .user;

                                        return KText(
                                          textAlign: TextAlign.start,
                                          text:
                                              "${user.firstName} ${user.lastName}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: isMobile
                                              ? 20
                                              : isTablet
                                              ? 22
                                              : 24,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              AppColorConstants.secondaryColor,
                                        );
                                      }

                                      return const SizedBox.shrink(); // or a loader if needed
                                    },
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
                    ),

                    // Doctor Dashboard SUMMARY TEXT
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

                    // Doctor Dashboard SUMMARY Counts
                    BlocBuilder<
                      DoctorDashboardSummaryCountsBloc,
                      DoctorDashboardSummaryCountsState
                    >(
                      builder: (context, state) {
                        // Loading State
                        if (state is GetDashboardSummaryCountsLoading) {
                          return Row(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: KSkeletonRectangle()),
                              Expanded(child: KSkeletonRectangle()),
                            ],
                          );
                        }

                        // Online or Offline Success State
                        if (state is GetDashboardSummaryCountsSuccess ||
                            state is GetDashboardSummaryCountsOfflineSuccess) {
                          final summary =
                              state is GetDashboardSummaryCountsSuccess
                              ? state.getDashboardCountsSummaryModel.summary
                              : (state as GetDashboardSummaryCountsOfflineSuccess)
                                    .getDashboardCountsSummaryModel
                                    .summary;

                          return Row(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount:
                                      summary?.totalPatient.toString() ?? '0',
                                  scoreCardTitle: appLoc.totalPatient,
                                  icon: Icons.person,
                                ),
                              ),

                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount:
                                      summary?.totalEducationArticles
                                          .toString() ??
                                      '0',
                                  scoreCardTitle: appLoc.totalEducationArticles,
                                  icon: Icons.school,
                                ),
                              ),
                            ],
                          );
                        }

                        // Failure State
                        if (state is GetDashboardSummaryCountsFailure) {
                          AppLoggerHelper.logError(
                            "Dashboard Summary Failure: ${state.message}",
                          );

                          return Center(
                            child: SizedBox(
                              height: screenHeight * 0.3,
                              child: KNoItemsFound(
                                noItemsSvg: AppAssetsConstants.failure,
                                noItemsFoundText: appLoc.somethingWentWrong,
                              ),
                            ),
                          );
                        }

                        return SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 30),

                    // Pre Operative Summary Text
                    KText(
                      textAlign: TextAlign.start,
                      text: appLoc.preOperativeSummary,
                      fontSize: isMobile
                          ? 20
                          : isTablet
                          ? 22
                          : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.titleColor,
                    ),

                    const SizedBox(height: 20),

                    // Pre Operative Summary Counts
                    BlocBuilder<
                      DoctorDashboardSummaryCountsBloc,
                      DoctorDashboardSummaryCountsState
                    >(
                      builder: (context, state) {
                        // Loading State
                        if (state is GetDashboardSummaryCountsLoading) {
                          return Row(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: KSkeletonRectangle()),
                              Expanded(child: KSkeletonRectangle()),
                              Expanded(child: KSkeletonRectangle()),
                            ],
                          );
                        }

                        // Online or Offline Success State
                        if (state is GetDashboardSummaryCountsSuccess ||
                            state is GetDashboardSummaryCountsOfflineSuccess) {
                          final preOperative =
                              state is GetDashboardSummaryCountsSuccess
                              ? state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative
                              : (state as GetDashboardSummaryCountsOfflineSuccess)
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .preOperative;

                          return Row(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: preOperative!.pending.toString(),
                                  scoreCardTitle: appLoc.pending,
                                  icon: Icons.pending_actions,
                                ),
                              ),

                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: preOperative.rejected.toString(),
                                  scoreCardTitle: appLoc.rejected,
                                  icon: Icons.clear,
                                ),
                              ),

                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: preOperative.completed.toString(),
                                  scoreCardTitle: appLoc.completed,
                                  icon: Icons.check_circle,
                                ),
                              ),
                            ],
                          );
                        }

                        // Failure State
                        if (state is GetDashboardSummaryCountsFailure) {
                          return Center(
                            child: SizedBox(
                              height: screenHeight * 0.3,
                              child: KNoItemsFound(
                                noItemsSvg: AppAssetsConstants.failure,
                                noItemsFoundText: appLoc.somethingWentWrong,
                              ),
                            ),
                          );
                        }

                        return SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 30),

                    // Post Operative Summary Text
                    KText(
                      textAlign: TextAlign.start,
                      text: appLoc.postOperativeSummary,
                      fontSize: isMobile
                          ? 20
                          : isTablet
                          ? 22
                          : 24,
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.titleColor,
                    ),

                    const SizedBox(height: 20),

                    // Post Operative Summary Counts
                    BlocBuilder<
                      DoctorDashboardSummaryCountsBloc,
                      DoctorDashboardSummaryCountsState
                    >(
                      builder: (context, state) {
                        // Loading State
                        if (state is GetDashboardSummaryCountsLoading) {
                          return Row(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: KSkeletonRectangle()),
                              Expanded(child: KSkeletonRectangle()),
                              Expanded(child: KSkeletonRectangle()),
                            ],
                          );
                        }

                        // Online or Offline Success State
                        if (state is GetDashboardSummaryCountsSuccess ||
                            state is GetDashboardSummaryCountsOfflineSuccess) {
                          final postOperative =
                              state is GetDashboardSummaryCountsSuccess
                              ? state
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative
                              : (state as GetDashboardSummaryCountsOfflineSuccess)
                                    .getDashboardCountsSummaryModel
                                    .summary!
                                    .postOperative;

                          return Row(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: postOperative!.pending.toString(),
                                  scoreCardTitle: appLoc.pending,
                                  icon: Icons.pending_actions,
                                ),
                              ),

                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: postOperative.rejected.toString(),
                                  scoreCardTitle: appLoc.rejected,
                                  icon: Icons.clear,
                                ),
                              ),

                              Expanded(
                                child: PeriOperativeScoreCard(
                                  totalCount: postOperative.completed
                                      .toString(),
                                  scoreCardTitle: appLoc.completed,
                                  icon: Icons.check_circle,
                                ),
                              ),
                            ],
                          );
                        }

                        // Failure State
                        if (state is GetDashboardSummaryCountsFailure) {
                          return Center(
                            child: SizedBox(
                              height: screenHeight * 0.3,
                              child: KNoItemsFound(
                                noItemsSvg: AppAssetsConstants.failure,
                                noItemsFoundText: appLoc.somethingWentWrong,
                              ),
                            ),
                          );
                        }

                        return SizedBox.shrink();
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
