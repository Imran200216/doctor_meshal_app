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

  // Fetch User Auth Data and Load Education
  Future<void> _fetchUserIdAndLoadEducation() async {
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

        // Trigger EducationBloc to fetch data
        context.read<EducationBloc>().add(GetEducationEvent(userId: userId!));
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

    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,

      appBar: KAppBarTitle(
        title: appLoc.patientCorner,
        backgroundColor: AppColorConstants.secondaryColor,
        titleColor: AppColorConstants.titleColor,
      ),

      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          final connectivityState = context.read<ConnectivityBloc>().state;

          // Correct internet check
          if (connectivityState is ConnectivityFailure ||
              (connectivityState is ConnectivitySuccess &&
                  connectivityState.isConnected == false)) {
            KSnackBar.error(context, appLoc.noInternet);
            return;
          }


          // INTERNET AVAILABLE → fetch userId & load education
          await _fetchUserIdAndLoadEducation();
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
                // Wrap only the list/grid with BlocBuilder
                BlocBuilder<ConnectivityBloc, ConnectivityState>(
                  builder: (context, connectivityState) {
                    // ❗ DO NOT SHOW No Internet UI — just log it.
                    final bool isOffline =
                        connectivityState is ConnectivityFailure;

                    // Continue showing Education list using offline data
                    return BlocBuilder<EducationBloc, EducationState>(
                      builder: (context, state) {
                        // LOADING
                        if (state is EducationLoading) {
                          return isTablet
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: 20,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 18,
                                        mainAxisSpacing: 18,
                                        childAspectRatio: 1.6,
                                      ),
                                  itemBuilder: (_, __) => KSkeletonRectangle(
                                    width: double.maxFinite,
                                    radius: 12,
                                    height: 160,
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: 20,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 18),
                                  itemBuilder: (_, __) => KSkeletonRectangle(
                                    width: double.maxFinite,
                                    radius: 12,
                                    height: 180,
                                  ),
                                );
                        }

                        // SUCCESS (ONLINE) or OFFLINE
                        if (state is EducationSuccess ||
                            state is EducationOfflineSuccess) {
                          final educations = state is EducationSuccess
                              ? state.educations
                              : (state as EducationOfflineSuccess).educations;

                          if (educations.isEmpty) {
                            return Align(
                              alignment: Alignment.center,
                              heightFactor: 3,
                              child: KNoItemsFound(),
                            );
                          }

                          return isTablet
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
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
                                      onTap: () =>
                                          GoRouter.of(context).pushNamed(
                                            AppRouterConstants
                                                .educationSubTopics,
                                            extra: edu.id,
                                          ),
                                      imageUrl: edu.image,
                                      title: edu.title,
                                      noOfArticles: edu.articleCounts,
                                      noOfTopics: edu.subTitleCounts,
                                    );
                                  },
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: educations.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 18),
                                  itemBuilder: (context, index) {
                                    final edu = educations[index];
                                    return PatientCornerCard(
                                      onTap: () =>
                                          GoRouter.of(context).pushNamed(
                                            AppRouterConstants
                                                .educationSubTopics,
                                            extra: edu.id,
                                          ),
                                      imageUrl: edu.image,
                                      title: edu.title,
                                      noOfArticles: edu.articleCounts,
                                      noOfTopics: edu.subTitleCounts,
                                    );
                                  },
                                );
                        }

                        // FAILURE (ONLY when online + offline empty)
                        if (state is EducationFailure) {
                          return Align(
                            alignment: Alignment.center,
                            heightFactor: 3,
                            child: SizedBox(
                              height: screenHeight * 0.3,
                              child: KNoItemsFound(
                                noItemsSvg: AppAssetsConstants.failure,
                                noItemsFoundText: appLoc.somethingWentWrong,
                              ),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    );
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
