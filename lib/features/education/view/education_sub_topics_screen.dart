import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class EducationSubTopicsScreen extends StatefulWidget {
  final String educationId;

  const EducationSubTopicsScreen({super.key, required this.educationId});

  @override
  State<EducationSubTopicsScreen> createState() =>
      _EducationSubTopicsScreenState();
}

class _EducationSubTopicsScreenState extends State<EducationSubTopicsScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchEducationSubTopics();
    super.initState();
  }

  // Fetch Education Sub Topics
  Future<void> _fetchEducationSubTopics() async {
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
        AppLoggerHelper.logInfo("Education ID: ${widget.educationId}");

        // Trigger Education Sub Title Bloc to fetch data
        context.read<EducationSubTitleBloc>().add(
          GetEducationSubTitleEvent(
            userId: userId!,
            educationTitleId: widget.educationId,
          ),
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

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.educationSubTopics,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      backgroundColor: AppColorConstants.secondaryColor,
      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Trigger Education Sub Title Bloc to fetch data
          _fetchEducationSubTopics();
        },
        child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, connectivityState) {
            if (connectivityState is ConnectivityFailure) {
              return Align(
                alignment: Alignment.center,
                heightFactor: 3,
                child: const KInternetFound(),
              );
            } else if (connectivityState is ConnectivitySuccess) {
              return BlocBuilder<EducationSubTitleBloc, EducationSubTitleState>(
                builder: (context, state) {
                  // Loading skeleton
                  if (state is EducationSubTitleLoading) {
                    return isTablet
                        ? GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
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
                  }

                  // Success state with data
                  if (state is EducationSubTitleSuccess) {
                    final subTopics = state.subtitles;

                    // Debug log using AppLoggerHelper
                    AppLoggerHelper.logInfo(
                      "Fetched SubTopics: ${subTopics.length}",
                    );

                    if (subTopics.isEmpty) {
                      return KNoItemsFound();
                    }

                    return isTablet
                        ? GridView.builder(
                            shrinkWrap: true,
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
                          )
                        : ListView.separated(
                            shrinkWrap: true,
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
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
                    return Align(
                      alignment: Alignment.center,
                      heightFactor: 3,
                      child: KNoItemsFound(
                        noItemsSvg: AppAssetsConstants.failure,
                        noItemsFoundText: appLoc.somethingWentWrong,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
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
}
