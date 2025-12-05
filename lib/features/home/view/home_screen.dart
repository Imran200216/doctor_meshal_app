import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // User Id
  String? userId;

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
        _fetchUserIdAndLoadEducation(),
        _fetchUserAuth(),
        _fetchOperativeSummaryCounts(),
        _viewUserChatRoom(),
        _initializeUserAndChat(),
        _fetchUserIdAndLoadNotificationsUnReadCount(),
      ]);

      AppLoggerHelper.logInfo("All data fetched successfully!");
    } catch (e) {
      AppLoggerHelper.logError("Error fetching data: $e");
    }
  }

  // Fetch User ID from userAuthData and Load Education
  Future<void> _fetchUserIdAndLoadEducation() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);
        final storedUser = UserAuthModel.fromJson(storedUserMap);

        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Dispatch event
        context.read<OperativeSummaryCountsBloc>().add(
          GetOperativeSummaryCountEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData from Hive: $e");
    }
  }

  // Fetch User Auth from userAuthData
  Future<void> _fetchUserAuth() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);
        final storedUser = UserAuthModel.fromJson(storedUserMap);

        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Dispatch event
        context.read<OperativeSummaryCountsBloc>().add(
          GetOperativeSummaryCountEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData from Hive: $e");
    }
  }

  // Fetch Operative Summary Counts using userAuthData
  Future<void> _fetchOperativeSummaryCounts() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);
        final storedUser = UserAuthModel.fromJson(storedUserMap);

        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Dispatch event
        context.read<OperativeSummaryCountsBloc>().add(
          GetOperativeSummaryCountEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData from Hive: $e");
    }
  }

  // View User Chat Room using userAuthData
  Future<void> _viewUserChatRoom() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);
        final storedUser = UserAuthModel.fromJson(storedUserMap);

        userId = storedUser.id;

        AppLoggerHelper.logInfo("User ID fetched from userAuthData: $userId");

        // Get View User Chat Room
        context.read<ViewUserChatRoomBloc>().add(
          GetViewChatRoomEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching userAuthData from Hive: $e");
    }
  }

  // Initialize User and Chat using userAuthData
  Future<void> _initializeUserAndChat() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Fetch stored userAuthData (no generic type)
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null && mounted) {
        // Convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        userId = storedUser.id;

        AppLoggerHelper.logInfo('👤 User ID from userAuthData: $userId');

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

  // Fetch User Auth Data and Doctor Patient Feedbacks
  Future<void> _fetchUserIdAndLoadNotificationsUnReadCount() async {
    try {
      // Open the Hive box if not already opened
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

        // Trigger View All Notification
        context.read<ViewNotificationUnReadCountBloc>().add(
          GetViewNotificationUnReadCountEvent(userId: userId!),
        );
      } else {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from userAuthData: $e");
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

        // Drawer
        drawer: HomeDrawer(),

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
              // Fetch All Data
              _fetchAllData();
            },

            child: CustomScrollView(
              slivers: [
                // HEADER SECTION
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColorConstants.primaryColor,
                          ),
                          child: Row(
                            children: [
                              /// LEFT SIDE (Text) - Should expand depending on screen size
                              Expanded(
                                child: Column(
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
                                        if (state is GetUserAuthSuccess) {
                                          return KText(
                                            textAlign: TextAlign.start,
                                            text:
                                                "${state.user.firstName} ${state.user.lastName}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: isMobile
                                                ? 20
                                                : isTablet
                                                ? 22
                                                : 24,
                                            fontWeight: FontWeight.w700,
                                            color: AppColorConstants
                                                .secondaryColor,
                                          );
                                        }

                                        return const SizedBox.shrink(); // or a loader if needed
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              /// RIGHT SIDE (Image)
                              Flexible(
                                child: Image.asset(
                                  AppAssetsConstants.doctorIntro,
                                  height: isMobile
                                      ? 140
                                      : isTablet
                                      ? 150
                                      : 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Peri-Operative Score
                            KText(
                              textAlign: TextAlign.start,
                              text: appLoc.periOperativeScore,
                              fontSize: isMobile
                                  ? 20
                                  : isTablet
                                  ? 22
                                  : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColorConstants.titleColor,
                            ),

                            const SizedBox(height: 20),

                            BlocBuilder<
                              OperativeSummaryCountsBloc,
                              OperativeSummaryCountsState
                            >(
                              builder: (context, state) {
                                // Loading State
                                if (state is GetOperativeSummaryCountsLoading) {
                                  return Row(
                                    spacing: 15,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: KSkeletonRectangle()),
                                      Expanded(child: KSkeletonRectangle()),
                                      Expanded(child: KSkeletonRectangle()),
                                    ],
                                  );
                                }

                                // Success State
                                if (state is GetOperativeSummaryCountsSuccess) {
                                  return Row(
                                    spacing: 15,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: PeriOperativeScoreCard(
                                          totalCount:
                                              state.submittedCountsOperative,
                                          scoreCardTitle:
                                              appLoc.totalFormSubmit,
                                          icon: Icons.speaker_notes,
                                        ),
                                      ),

                                      Expanded(
                                        child: PeriOperativeScoreCard(
                                          totalCount: state.preOperativeCounts,
                                          scoreCardTitle: appLoc.preOpSubmit,
                                          icon: Icons.speaker_notes,
                                        ),
                                      ),

                                      Expanded(
                                        child: PeriOperativeScoreCard(
                                          totalCount: state.postOperativeCounts,
                                          scoreCardTitle: appLoc.postOpSubmit,
                                          icon: Icons.speaker_notes,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                // Failure State
                                if (state is GetOperativeSummaryCountsFailure) {
                                  return Center(
                                    child: SizedBox(
                                      height: screenHeight * 0.3,
                                      child: KNoItemsFound(
                                        noItemsSvg: AppAssetsConstants.failure,
                                        noItemsFoundText:
                                            appLoc.somethingWentWrong,
                                      ),
                                    ),
                                  );
                                }

                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        KText(
                          textAlign: TextAlign.start,
                          text: appLoc.patientCorner,
                          fontSize: isMobile
                              ? 20
                              : isTablet
                              ? 22
                              : 24,
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.titleColor,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // EDUCATION BLOC SECTION
                BlocBuilder<EducationBloc, EducationState>(
                  builder: (context, state) {
                    if (state is EducationLoading) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: _buildEducationLoadingSliver(isTablet),
                      );
                    }

                    if (state is EducationSuccess) {
                      final educations = state.educations;

                      if (educations.isEmpty) {
                        return const SliverToBoxAdapter(child: KNoItemsFound());
                      }

                      return isTablet
                          ? SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              sliver: _buildEducationGridSliver(educations),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              sliver: _buildEducationListSliver(educations),
                            );
                    }

                    if (state is EducationFailure) {
                      return SliverToBoxAdapter(
                        child: Center(child: Text(state.message)),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // LOADING STATE
  SliverGrid _buildEducationLoadingSliver(bool isTablet) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 1,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: isTablet ? 1.6 : 3,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return Skeletonizer(
          enabled: true,
          child: PatientCornerCard(
            onTap: () {},
            imageUrl: "",
            title: "",
            noOfArticles: "",
            noOfTopics: "",
          ),
        );
      }, childCount: 10),
    );
  }

  // GRID VIEW (TABLET)
  SliverGrid _buildEducationGridSliver(List educations) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.6,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final edu = educations[index];
        return PatientCornerCard(
          onTap: () {
            GoRouter.of(
              context,
            ).pushNamed(AppRouterConstants.educationSubTopics, extra: edu.id);
          },
          imageUrl: edu.image,
          title: edu.title,
          noOfArticles: edu.articleCounts.toString(),
          noOfTopics: edu.subTitleCounts.toString(),
        );
      }, childCount: educations.length),
    );
  }

  // LIST VIEW (MOBILE)
  SliverList _buildEducationListSliver(List educations) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final edu = educations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: PatientCornerCard(
            onTap: () {
              GoRouter.of(
                context,
              ).pushNamed(AppRouterConstants.educationSubTopics, extra: edu.id);
            },
            imageUrl: edu.image,
            title: edu.title,
            noOfArticles: edu.articleCounts.toString(),
            noOfTopics: edu.subTitleCounts.toString(),
          ),
        );
      }, childCount: educations.length),
    );
  }
}
