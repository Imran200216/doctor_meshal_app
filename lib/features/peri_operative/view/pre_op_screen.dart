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

  // Fetch Pre Operative Form using userAuthData
  Future<void> _fetchPreOperative() async {
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

        // Dispatch Event to Fetch Pre Operative Form
        context.read<OperativeFormBloc>().add(
          GetOperativeFormEvents(userId: userId!, formType: "pre"),
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
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.periOperative,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: Builder(
        builder: (rootContext) {
          return RefreshIndicator.adaptive(
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

              // Fetch Peri Operative Form
              await _fetchPreOperative();
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
                            ? operativeFormEvents.isEmpty
                                  ? KNoItemsFound()
                                  : GridView.builder(
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
                                            if (item.formEnableStatus ==
                                                false) {
                                              KSnackBar.error(
                                                rootContext,
                                                "Survey Locked!",
                                              );
                                            } else if (item.formEnableStatus ==
                                                true) {
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
                            : operativeFormEvents.isEmpty
                            ? KNoItemsFound()
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
                                        return KSnackBar.error(
                                          rootContext,
                                          "Survey Locked!",
                                        );
                                      } else if (item.formEnableStatus ==
                                          true) {
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
                        AppLoggerHelper.logError("Error: ${state.message}");

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
          );
        },
      ),
    );
  }
}
