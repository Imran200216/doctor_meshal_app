import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class ViewDoctorFeedbackScreen extends StatefulWidget {
  const ViewDoctorFeedbackScreen({super.key});

  @override
  State<ViewDoctorFeedbackScreen> createState() =>
      _ViewDoctorFeedbackScreenState();
}

class _ViewDoctorFeedbackScreenState extends State<ViewDoctorFeedbackScreen> {

  // UserId
  String? userId;

  @override
  void initState() {
    _fetchUserIdAndLoadDoctorPatientFeedbacks();
    super.initState();
  }

  // Fetch User Auth Data and Doctor Patient Feedbacks
  Future<void> _fetchUserIdAndLoadDoctorPatientFeedbacks() async {
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
        context.read<DoctorFeedbackBloc>().add(
          GetDoctorPatientFeedbacksEvent(userId: userId!),
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
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColorConstants.secondaryColor,
        appBar: KAppBar(
          title: appLoc.patientFeedbacks,
          onBack: () => GoRouter.of(context).pop(),
          backgroundColor: AppColorConstants.primaryColor,
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

            await _fetchUserIdAndLoadDoctorPatientFeedbacks();
          },

          child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, connectivityState) {
              if (connectivityState is ConnectivitySuccess) {
                return BlocBuilder<DoctorFeedbackBloc, DoctorFeedbackState>(
                  builder: (context, state) {
                    if (state is GetPatientFeedbacksLoading) {
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        itemCount: 30,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          return KSkeletonRectangle(
                            height: isMobile
                                ? 80
                                : isTablet
                                ? 90
                                : 100,
                            width: double.maxFinite,
                          );
                        },
                      );
                    }

                    if (state is GetPatientFeedbacksSuccess) {
                      final item = state.feedbacks;

                      if (item.isEmpty) {
                        return Align(
                          heightFactor: 0.4,
                          alignment: Alignment.center,
                          child: KNoItemsFound(),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final feedBackItems = state.feedbacks[index];

                          return FeedbackListTile(
                            patientName:
                                "${feedBackItems.patient.firstName} ${feedBackItems.patient.lastName}",
                            patientImageUrl: feedBackItems.patient.profileImage,
                            feedbackDateSubmitted: feedBackItems.createdAt,
                            onTap: () {
                              // View Full Doctor Feedback Content Screen
                              GoRouter.of(context).pushNamed(
                                AppRouterConstants
                                    .viewFullDoctorFeedbackContent,
                                extra: {
                                  "patientName":
                                      "${feedBackItems.patient.firstName} ${feedBackItems.patient.lastName}",
                                  "feedBackSubmittedDate":
                                      feedBackItems.createdAt,
                                  "patientFeedbackContent":
                                      feedBackItems.feedBack,
                                },
                              );
                            },
                            patientFeedbackContent: feedBackItems.feedBack,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            color: AppColorConstants.subTitleColor.withOpacity(
                              0.2,
                            ),
                          );
                        },
                        itemCount: state.feedbacks.length,
                      );
                    }

                    if (state is GetPatientFeedbacksFailure) {
                      AppLoggerHelper.logError(state.message);
                      return Center(
                        child: SizedBox(
                          height: screenHeight * 0.6,
                          child: KNoItemsFound(
                            noItemsSvg: AppAssetsConstants.failure,
                            noItemsFoundText: appLoc.somethingWentWrong,
                          ),
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  },
                );
              }

              if (connectivityState is ConnectivityFailure) {
                return Center(
                  child: SizedBox(
                    height: screenHeight * 0.4,
                    child: KNoItemsFound(
                      noItemsSvg: AppAssetsConstants.noInternetFound,
                      noItemsFoundText: appLoc.noInternet,
                    ),
                  ),
                );
              }

              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
