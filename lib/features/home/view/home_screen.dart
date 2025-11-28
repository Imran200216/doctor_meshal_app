import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        _fetchUserIdAndLoadEducation(),
        _fetchUserAuth(),
        _fetchOperativeSummaryCounts(),
        _viewUserChatRoom(),
      ]);

      AppLoggerHelper.logInfo("All data fetched successfully!");
    } catch (e) {
      AppLoggerHelper.logError("Error fetching data: $e");
    }
  }

  // Fetch Use Id And Load Education
  Future<void> _fetchUserIdAndLoadEducation() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo("User ID fetched from Hive: $userId");

        context.read<EducationBloc>().add(GetEducationEvent(userId: userId!));
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from Hive: $e");
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

  // Fetch Education Articles
  Future<void> _fetchOperativeSummaryCounts() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Get Operative Summary Counts
        context.read<OperativeSummaryCountsBloc>().add(
          GetOperativeSummaryCountEvent(userId: userId!),
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
                    child: BlocBuilder<UserAuthBloc, UserAuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColorConstants.primaryColor,
                              ),
                              child: Row(
                                children: [
                                  /// LEFT SIDE (Text) - Should expand depending on screen size
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          textAlign: TextAlign.start,
                                          text:
                                              "${getGreetingMessage(appLoc)},",
                                          fontSize: isMobile
                                              ? 22
                                              : isTablet
                                              ? 24
                                              : 26,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              AppColorConstants.secondaryColor,
                                        ),

                                        const SizedBox(height: 5),

                                        if (state is GetUserAuthSuccess)
                                          KText(
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

                            BlocBuilder<
                              OperativeSummaryCountsBloc,
                              OperativeSummaryCountsState
                            >(
                              builder: (context, state) {
                                if (state is GetOperativeSummaryCountsLoading) {
                                  return HomeSkeleton();
                                }

                                if (state is GetOperativeSummaryCountsSuccess) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                                      PeriOperativeScoreCard(
                                        totalCount:
                                            state.submittedCountsOperative,
                                        scoreCardTitle: appLoc.totalFormSubmit,
                                        icon: Icons.speaker_notes,
                                      ),
                                      const SizedBox(height: 15),

                                      PeriOperativeScoreCard(
                                        totalCount: state.preOperativeCounts,
                                        scoreCardTitle: appLoc.preOpSubmit,
                                        icon: Icons.speaker_notes,
                                      ),
                                      const SizedBox(height: 15),

                                      PeriOperativeScoreCard(
                                        totalCount: state.postOperativeCounts,
                                        scoreCardTitle: appLoc.postOpSubmit,
                                        icon: Icons.speaker_notes,
                                      ),
                                    ],
                                  );
                                }

                                if (state is GetOperativeSummaryCountsFailure) {
                                  AppLoggerHelper.logError(state.message);
                                }

                                return const SizedBox.shrink();
                              },
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
                        );
                      },
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
