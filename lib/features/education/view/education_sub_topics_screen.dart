import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education_sub_title/education_sub_title_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/widgets/education_sub_topics_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EducationSubTopicsScreen extends StatefulWidget {
  final String educationId;

  const EducationSubTopicsScreen({super.key, required this.educationId});

  @override
  State<EducationSubTopicsScreen> createState() =>
      _EducationSubTopicsScreenState();
}

class _EducationSubTopicsScreenState extends State<EducationSubTopicsScreen> {
  String? userId;

  @override
  void initState() {
    _fetchEducationSubTopics();
    super.initState();
  }

  Future<void> _fetchEducationSubTopics() async {
    try {
      // Open the Hive box if not already opened
      await HiveService.openBox(AppDBConstants.userBox);

      // Read userId from Hive
      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo("User ID fetched from Hive: $userId");
        AppLoggerHelper.logInfo("Education ID: ${widget.educationId}");

        // Trigger Education Sub Title Bloc to fetch data
        context.read<EducationSubTitleBloc>().add(
          GetEducationSubTitleEvent(
            userId: userId!,
            educationTitleId: widget.educationId,
          ),
        );
      } else {
        AppLoggerHelper.logError("No User ID found in Hive!");
      }
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID from Hive: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.educationSubTopics,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      backgroundColor: AppColorConstants.secondaryColor,
      body: BlocBuilder<EducationSubTitleBloc, EducationSubTitleState>(
        builder: (context, state) {
          // Loading skeleton
          if (state is EducationSubTitleLoading) {
            return isTablet
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 1.6,
                        ),
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
                        child: EducationSubTopicsCard(
                          onTap: () {},
                          imageUrl: "",
                          title: "",
                          noOfArticles: "",
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
                        child: EducationSubTopicsCard(
                          onTap: () {},
                          imageUrl: "",
                          title: "",
                          noOfArticles: "",
                        ),
                      );
                    },
                  );
          }

          // Success state with data
          if (state is EducationSubTitleSuccess) {
            final subTopics = state.subtitles;

            // Debug log using AppLoggerHelper
            AppLoggerHelper.logInfo("Fetched SubTopics: ${subTopics.length}");

            if (subTopics.isEmpty) {
              return KNoItemsFound();
            }

            return isTablet
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: subTopics.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 1.6,
                        ),
                    itemBuilder: (context, index) {
                      final subTopic = subTopics[index];
                      return EducationSubTopicsCard(
                        onTap: () {},
                        imageUrl: subTopic.image,
                        title: subTopic.subTitleName,
                        noOfArticles: subTopic.educationArticleCounts
                            .toString(),
                      );
                    },
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: subTopics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final subTopic = subTopics[index];
                      return EducationSubTopicsCard(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            AppRouterConstants.educationArticles,
                            extra: subTopic.id,
                          );
                        },
                        imageUrl: subTopic.image,
                        title: subTopic.subTitleName,
                        noOfArticles: subTopic.educationArticleCounts
                            .toString(),
                      );
                    },
                  );
          }

          // Failure state
          if (state is EducationSubTitleFailure) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
