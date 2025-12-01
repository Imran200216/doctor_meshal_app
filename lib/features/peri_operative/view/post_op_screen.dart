import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class PostOpScreen extends StatefulWidget {
  const PostOpScreen({super.key});

  @override
  State<PostOpScreen> createState() => _PostOpScreenState();
}

class _PostOpScreenState extends State<PostOpScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    _fetchPostOperative();

    super.initState();
  }

  // Fetch Post Operation Forms
  Future<void> _fetchPostOperative() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      // Get full stored user data
      final storedUserMap = await HiveService.getData<Map>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMap == null) {
        AppLoggerHelper.logError("No userAuthData found in Hive!");
        return;
      }

      // Convert Map → UserAuthModel
      final storedUser = UserAuthModel.fromJson(
        Map<String, dynamic>.from(storedUserMap),
      );

      // Extract ID
      final String? storedUserId = storedUser.id;

      if (storedUserId == null) {
        AppLoggerHelper.logError("User ID is NULL inside userAuthData!");
        return;
      }

      userId = storedUserId;

      AppLoggerHelper.logInfo("Post Operative → User ID fetched: $userId");

      // Dispatch event
      context.read<OperativeFormBloc>().add(
        GetOperativeFormEvents(userId: userId!, formType: "post"),
      );
    } catch (e) {
      AppLoggerHelper.logError("Error fetching User ID for Post Operative: $e");
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
        title: appLoc.postOperative,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: RefreshIndicator.adaptive(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          // Fetch Post Operation Forms
          _fetchPostOperative();
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
              return BlocBuilder<OperativeFormBloc, OperativeFormState>(
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
