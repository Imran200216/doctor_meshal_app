import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class SurveyFormScreen extends StatefulWidget {
  final String operativeId;

  const SurveyFormScreen({super.key, required this.operativeId});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchSurveyFormData();
  }

  // Fetch Survey Form Data
  Future<void> _fetchSurveyFormData() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);
      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;
        AppLoggerHelper.logInfo("User ID fetched: $userId");
        AppLoggerHelper.logInfo("Operative ID fetched: ${widget.operativeId}");

        context.read<SurveyOperativeFormBloc>().add(
          GetSurveyOperativeForm(userId: userId!, id: widget.operativeId),
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
      child: BlocConsumer<SurveyOperativeFormBloc, SurveyOperativeFormState>(
        listener: (context, state) {
          if (state is AddSurveyOperativeFormSuccess) {
            KSnackBar.success(context, "Form Submitted Successfully");
            context.read<SurveyFormSelectionCubit>().clearOptions();
            // GoRouter.of(context).pop();

            final userAuthState = context.read<UserAuthBloc>().state;

            if (userAuthState is GetUserAuthSuccess) {
              final userType = userAuthState.user.userType;

              if (userType == 'doctor' || userType == 'admin') {
                GoRouter.of(
                  context,
                ).pushReplacementNamed(AppRouterConstants.doctorBottomNav);
              } else {
                GoRouter.of(
                  context,
                ).pushReplacementNamed(AppRouterConstants.patientBottomNav);
              }
            }
          } else if (state is AddSurveyOperativeFormError) {
            KSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          // Get selections from Cubit
          final selections = context
              .watch<SurveyFormSelectionCubit>()
              .state
              .selections;
          final hasUserSelectedSomething = selections.values.any(
            (value) => value != null,
          );

          // Determine if all sections are selected
          bool allSelected = false;
          if (state is SurveyOperativeFormSuccess) {
            final form = state.surveyOperativeForm;
            allSelected =
                form.formSection.isNotEmpty &&
                selections.values.length == form.formSection.length &&
                selections.values.every((value) => value != null);
          }

          // Single Scaffold for all states
          return Scaffold(
            backgroundColor: AppColorConstants.secondaryColor,
            appBar: KAppBar(
              title: (state is SurveyOperativeFormSuccess)
                  ? state.surveyOperativeForm.title
                  : "Survey Form",
              onBack: () {
                if (!hasUserSelectedSomething) {
                  GoRouter.of(context).pop();
                  return;
                }
                // Show confirmation dialog if user has selected options
                showDialog(
                  context: context,
                  builder: (context) => KAlertDialog(
                    cancelText: appLoc.cancel,
                    confirmText: appLoc.back,
                    titleText: appLoc.alertSurveyFormTitle,
                    contentText: appLoc.alertSurveyFormDescription,
                    onCancelTap: () => GoRouter.of(context).pop(),
                    onConfirmTap: () {
                      context.read<SurveyFormSelectionCubit>().clearOptions();
                      GoRouter.of(context).pop();
                      GoRouter.of(context).pop();
                    },
                  ),
                );
              },
            ),
            body: Builder(
              builder: (context) {
                if (state is SurveyOperativeFormLoading ||
                    state is AddSurveyOperativeFormLoading) {
                  return SurveyFormSkeleton();
                }

                if (state is SurveyOperativeFormError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                if (state is SurveyOperativeFormSuccess) {
                  final form = state.surveyOperativeForm;

                  if (form.formSection.isEmpty) return KNoItemsFound();

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: isMobile
                          ? 20
                          : isTablet
                          ? 30
                          : 40,
                      right: isMobile
                          ? 20
                          : isTablet
                          ? 30
                          : 40,
                      top: isMobile
                          ? 20
                          : isTablet
                          ? 30
                          : 40,
                      bottom: isMobile
                          ? 240
                          : isTablet
                          ? 260
                          : 280,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: form.formSection.length,
                          itemBuilder: (context, index) {
                            final section = form.formSection[index];
                            return SurveyFormCard(
                              question: section.sectionTitle,
                              options: section.formOption
                                  .map(
                                    (e) => "${e.optionName} (${e.points} pts)",
                                  )
                                  .toList(),
                              selectedIndex: selections[index],
                              onOptionSelected: (selected) {
                                context
                                    .read<SurveyFormSelectionCubit>()
                                    .selectOption(index, selected);
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                        ),
                        if (allSelected)
                          _buildSummary(form, selections, isMobile, isTablet),
                      ],
                    ),
                  );
                }

                // Default empty
                return const SizedBox.shrink();
              },
            ),
            bottomSheet: (state is SurveyOperativeFormSuccess && allSelected)
                ? _buildBottomSheet(
                    context,
                    state.surveyOperativeForm,
                    selections,
                    isMobile,
                    isTablet,
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildSummary(
    form,
    Map<int, int?> selections,
    bool isMobile,
    bool isTablet,
  ) {
    int totalPoints = 0;
    for (int i = 0; i < form.formSection.length; i++) {
      final selectedIndex = selections[i];
      if (selectedIndex != null) {
        totalPoints +=
            int.tryParse(
              form.formSection[i].formOption[selectedIndex].points.toString(),
            ) ??
            0;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColorConstants.subTitleColor.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KText(
            text: "Summary",
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.titleColor,
          ),
          const SizedBox(height: 10),
          ...List.generate(form.formSection.length, (index) {
            final section = form.formSection[index];
            final selectedIndex = selections[index];
            final optionName = selectedIndex != null
                ? section.formOption[selectedIndex].optionName
                : "None";
            final points = selectedIndex != null
                ? section.formOption[selectedIndex].points
                : 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KText(
                    text: "${index + 1}. ${section.sectionTitle}",
                    fontSize: isMobile
                        ? 13
                        : isTablet
                        ? 16
                        : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColorConstants.titleColor,
                  ),
                  KText(
                    text: "Ans: $optionName ($points pts)",
                    fontSize: isMobile
                        ? 13
                        : isTablet
                        ? 16
                        : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColorConstants.titleColor,
                  ),
                ],
              ),
            );
          }),
          KText(
            text: "Total Score: $totalPoints points",
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.titleColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    form,
    Map<int, int?> selections,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: isMobile
          ? 120
          : isTablet
          ? 140
          : 160,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColorConstants.secondaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppColorConstants.subTitleColor.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: KFilledBtn(
          isLoading:
              context.watch<SurveyOperativeFormBloc>().state
                  is AddSurveyOperativeFormLoading,
          btnTitle: "Submit Form",
          btnBgColor: AppColorConstants.primaryColor,
          btnTitleColor: AppColorConstants.secondaryColor,
          onTap: () {
            List<String> inputFormItems = [];
            int totalPoints = 0;

            for (int i = 0; i < form.formSection.length; i++) {
              final section = form.formSection[i];
              final selectedIndex = selections[i];

              String name;
              String points;
              String id = section.id.toString();

              if (selectedIndex != null) {
                final selectedOption = section.formOption[selectedIndex];
                name = selectedOption.optionName.toString();
                points = selectedOption.points.toString();
                totalPoints += int.tryParse(points) ?? 0;
              } else {
                name = "None";
                points = "0";
              }

              inputFormItems.add(
                '{index: $i, name: "$name", points: "$points", id: "$id"}',
              );
            }

            final inputFormStr = '[${inputFormItems.join(', ')}]';
            final totalPointsStr = totalPoints.toString();

            AppLoggerHelper.logInfo("GraphQL Input Form: $inputFormStr");
            AppLoggerHelper.logInfo("Total Points: $totalPointsStr");

            context.read<SurveyOperativeFormBloc>().add(
              AddSurveyOperativeForm(
                userId: userId!,
                operativeFormId: widget.operativeId,
                totalPoints: totalPointsStr,
                inputForm: inputFormStr,
              ),
            );
          },
          borderRadius: 12,
          fontSize: isMobile
              ? 16
              : isTablet
              ? 18
              : 20,
          btnHeight: isMobile
              ? 50
              : isTablet
              ? 52
              : 54,
          btnWidth: double.maxFinite,
        ),
      ),
    );
  }
}
