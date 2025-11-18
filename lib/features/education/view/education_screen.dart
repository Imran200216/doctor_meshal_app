import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_no_items_found.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_skeleton_rectangle.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/education/view_model/education/education_bloc.dart';
import 'package:meshal_doctor_booking_app/features/education/widgets/patient_corner_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndLoadEducation();
  }

  Future<void> _fetchUserIdAndLoadEducation() async {
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

        // Trigger EducationBloc to fetch data
        context.read<EducationBloc>().add(GetEducationEvent(userId: userId!));
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
      backgroundColor: AppColorConstants.secondaryColor,
      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Trigger EducationBloc to fetch data
          _fetchUserIdAndLoadEducation();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: appLoc.patientCorner,
                  fontSize: isMobile
                      ? 22
                      : isTablet
                      ? 24
                      : 26,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.titleColor,
                ),
                const SizedBox(height: 20),

                // Wrap only the list/grid with BlocBuilder
                BlocBuilder<EducationBloc, EducationState>(
                  builder: (context, state) {
                    if (state is EducationLoading) {
                      return isTablet
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                    childAspectRatio: 1.6,
                                  ),
                              itemBuilder: (context, index) {
                                return KSkeletonRectangle(
                                  width: double.maxFinite,
                                  radius: 12,
                                  height: 160,
                                );
                              },
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 18),
                              itemBuilder: (context, index) {
                                return KSkeletonRectangle(
                                  width: double.maxFinite,
                                  radius: 12,
                                  height: 180,
                                );
                              },
                            );
                    } else if (state is EducationSuccess) {
                      final educations = state.educations;
                      if (educations.isEmpty) {
                        return KNoItemsFound();
                      }

                      return isTablet
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: educations.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                    childAspectRatio: 1.6,
                                  ),
                              itemBuilder: (context, index) {
                                final edu = educations[index];
                                return PatientCornerCard(
                                  onTap: () {
                                    // Education Sub Topics
                                    GoRouter.of(context).pushNamed(
                                      AppRouterConstants.educationSubTopics,
                                      extra: edu.id,
                                    );
                                  },
                                  imageUrl: edu.image,
                                  title: edu.title,
                                  noOfArticles: edu.articleCounts.toString(),
                                  noOfTopics: edu.subTitleCounts.toString(),
                                );
                              },
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: educations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 18),
                              itemBuilder: (context, index) {
                                final edu = educations[index];
                                return PatientCornerCard(
                                  onTap: () {
                                    // Education Sub Topics
                                    GoRouter.of(context).pushNamed(
                                      AppRouterConstants.educationSubTopics,
                                      extra: edu.id,
                                    );
                                  },
                                  imageUrl: edu.image,
                                  title: edu.title,
                                  noOfArticles: edu.articleCounts.toString(),
                                  noOfTopics: edu.subTitleCounts.toString(),
                                );
                              },
                            );
                    } else if (state is EducationFailure) {
                      return Center(child: Text(state.message));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
