import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_snack_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/operative_form/operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/widgets/operative_form_survey_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PreOpScreen extends StatefulWidget {
  const PreOpScreen({super.key});

  @override
  State<PreOpScreen> createState() => _PreOpScreenState();
}

class _PreOpScreenState extends State<PreOpScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchPreOperative();

    super.initState();
  }

  // Fetch Peri Operative Form
  Future<void> _fetchPreOperative() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");

        // Get Operative Form Events
        context.read<OperativeFormBloc>().add(
          GetOperativeFormEvents(userId: userId!, formType: "pre"),
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

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.periOperative,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: RefreshIndicator(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Fetch Peri Operative Form
          _fetchPreOperative();
        },
        child: BlocBuilder<OperativeFormBloc, OperativeFormState>(
          builder: (context, state) {
            // Loading State
            if (state is OperativeFormLoading) {
              return isTablet
                  ? GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
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
                      itemCount: 40,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 1.8,
                          ),
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          effect: ShimmerEffect(),
                          enabled: true,
                          child: OperativeFormSurveyCard(
                            title: "",
                            onSurveyTap: () {},
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      scrollDirection: Axis.vertical,
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
                      itemBuilder: (context, index) {
                        return Skeletonizer(
                          effect: ShimmerEffect(),
                          enabled: true,
                          child: OperativeFormSurveyCard(
                            title: "",
                            onSurveyTap: () {},
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemCount: 40,
                    );
            }

            // Success State
            if (state is OperativeFormSuccess) {
              final operativeFormEvents = state.operativeForm;

              return isTablet
                  ? GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
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
                      itemCount: operativeFormEvents.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            childAspectRatio: 1.8,
                          ),
                      itemBuilder: (context, index) {
                        final item = operativeFormEvents[index];

                        return OperativeFormSurveyCard(
                          isFormEnabled: item.formEnableStatus,
                          title: item.title,
                          onSurveyTap: () {
                            if (item.formEnableStatus == false) {
                              KSnackBar.error(context, "Survey Locked!");
                            } else if (item.formEnableStatus == true) {
                              // Survey Form Screen
                              GoRouter.of(context).pushNamed(
                                AppRouterConstants.surveyForm,
                                extra: item.id,
                              );
                            }
                          },
                        );
                      },
                    )
                  : ListView.separated(
                      scrollDirection: Axis.vertical,
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
                      itemBuilder: (context, index) {
                        final item = operativeFormEvents[index];
                        return OperativeFormSurveyCard(
                          isFormEnabled: item.formEnableStatus,
                          title: item.title,
                          onSurveyTap: () {
                            if (item.formEnableStatus == false) {
                              KSnackBar.error(context, "Survey Locked!");
                            } else if (item.formEnableStatus == true) {
                              // Survey Form Screen
                              GoRouter.of(context).pushNamed(
                                AppRouterConstants.surveyForm,
                                extra: item.id,
                              );
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemCount: operativeFormEvents.length,
                    );
            }

            if (state is OperativeFormFailure) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
