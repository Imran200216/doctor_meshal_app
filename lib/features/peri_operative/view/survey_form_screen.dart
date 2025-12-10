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

  // Fetch Survey Form Data using userAuthData
  Future<void> _fetchSurveyFormData() async {
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

        // Dispatch event to get survey operative form
        context.read<SurveyOperativeFormBloc>().add(
          GetSurveyOperativeForm(userId: userId!, id: widget.operativeId),
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
          final selectionState =
              context.watch<SurveyFormSelectionCubit>().state
                  as SurveyFormSelected;

          // Check if user has selected something
          final hasUserSelectedSomething =
              selectionState.singleSelections.isNotEmpty ||
              selectionState.multiSelections.isNotEmpty ||
              selectionState.answerTexts.isNotEmpty;

          // Determine if all sections are selected
          bool allSelected = false;
          if (state is SurveyOperativeFormSuccess) {
            final form = state.surveyOperativeForm;

            // Check if each section has a selection based on its type
            allSelected = form.formSection.asMap().entries.every((entry) {
              final index = entry.key;
              final section = entry.value;

              if (section.chooseType == "single-choice") {
                return selectionState.singleSelections[index] != null;
              } else if (section.chooseType == "multiple-choice") {
                final selections = selectionState.multiSelections[index];
                return selections != null && selections.isNotEmpty;
              } else if (section.chooseType == "answer") {
                final answer = selectionState.answerTexts[index];
                return answer != null && answer.trim().isNotEmpty;
              }
              return false;
            });
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

                            if (section.chooseType == "single-choice") {
                              return SurveyFormCard(
                                question: section.sectionTitle,
                                options: section.formOption
                                    .map(
                                      (e) =>
                                          "${e.optionName} (${e.points} pts)",
                                    )
                                    .toList(),
                                selectedIndex:
                                    selectionState.singleSelections[index],
                                onOptionSelected: (selected) {
                                  context
                                      .read<SurveyFormSelectionCubit>()
                                      .selectSingleOption(index, selected);
                                },
                              );
                            } else if (section.chooseType ==
                                "multiple-choice") {
                              return SurveyFormMultiCard(
                                key: ValueKey('multi-card-$index'),
                                question: section.sectionTitle,
                                options: section.formOption
                                    .map(
                                      (e) =>
                                          "${e.optionName} (${e.points} pts)",
                                    )
                                    .toList(),
                                selectedIndexes:
                                    selectionState.multiSelections[index] ?? [],
                                onMultiSelect: (optionIndex) {
                                  context
                                      .read<SurveyFormSelectionCubit>()
                                      .toggleMultiOption(index, optionIndex);
                                },
                              );
                            } else if (section.chooseType == "answer") {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: section.sectionTitle,
                                    fontSize: isMobile
                                        ? 14
                                        : isTablet
                                        ? 16
                                        : 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 10),
                                  KTextFormField(
                                    hintText: "Type your answer here...",
                                    onChanged: (value) {
                                      context
                                          .read<SurveyFormSelectionCubit>()
                                          .updateAnswer(index, value);
                                    },
                                    maxLines: 3,
                                    controller: TextEditingController(
                                      text:
                                          selectionState.answerTexts[index] ??
                                          "",
                                    ),
                                  ),
                                ],
                              );
                            }

                            return const SizedBox(); // fallback
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 20),
                        ),
                        if (allSelected)
                          _buildSummary(
                            form,
                            selectionState,
                            isMobile,
                            isTablet,
                          ),
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
                    selectionState,
                    isMobile,
                    isTablet,
                  )
                : null,
          );
        },
      ),
    );
  }

  // Add this helper function
  int _getPointsAsInt(dynamic points) {
    if (points == null) return 0;

    if (points is num) {
      return points.toInt();
    } else if (points is String) {
      // Try to parse the string to a number
      try {
        return int.tryParse(points) ?? 0;
      } catch (e) {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Widget _buildSummary(
    dynamic form,
    SurveyFormSelected selectionState,
    bool isMobile,
    bool isTablet,
  ) {
    int totalPoints = 0;

    // Calculate total points
    form.formSection.asMap().forEach((index, section) {
      if (section.chooseType == "single-choice") {
        final selectedIndex = selectionState.singleSelections[index];
        if (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < section.formOption.length) {
          totalPoints += _getPointsAsInt(
            section.formOption[selectedIndex].points,
          );
        }
      } else if (section.chooseType == "multiple-choice") {
        final selectedIndexes = selectionState.multiSelections[index] ?? [];
        for (final optionIndex in selectedIndexes) {
          if (optionIndex >= 0 && optionIndex < section.formOption.length) {
            totalPoints += _getPointsAsInt(
              section.formOption[optionIndex].points,
            );
          }
        }
      }
      // Text answers typically don't have points
    });

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
            String answerText = "Not answered";

            if (section.chooseType == "answer") {
              answerText = selectionState.answerTexts[index] ?? "Not answered";
            } else if (section.chooseType == "single-choice") {
              final selectedIndex = selectionState.singleSelections[index];
              if (selectedIndex != null &&
                  selectedIndex >= 0 &&
                  selectedIndex < section.formOption.length) {
                final option = section.formOption[selectedIndex];
                // Convert num to int for display using _getPointsAsInt
                final points = _getPointsAsInt(option.points);
                answerText = "${option.optionName} ($points pts)";
              } else {
                answerText = "Not selected";
              }
            } else if (section.chooseType == "multiple-choice") {
              final selectedIndexes =
                  selectionState.multiSelections[index] ?? [];
              if (selectedIndexes.isNotEmpty) {
                answerText = selectedIndexes
                    .where((idx) => idx >= 0 && idx < section.formOption.length)
                    .map((idx) {
                      final option = section.formOption[idx];
                      final points = _getPointsAsInt(option.points);
                      return "${option.optionName} ($points pts)";
                    })
                    .join(", ");
              } else {
                answerText = "Not selected";
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KText(
                    text: "${index + 1}. ${section.sectionTitle}",
                    fontSize: isMobile
                        ? 13
                        : isTablet
                        ? 15
                        : 17,
                    fontWeight: FontWeight.w600,
                    color: AppColorConstants.titleColor,
                  ),
                  const SizedBox(height: 4),
                  KText(
                    text: "Answer: $answerText",
                    maxLines: 5,
                    softWrap: true,
                    fontSize: isMobile
                        ? 12
                        : isTablet
                        ? 14
                        : 16,
                    fontWeight: FontWeight.w400,
                    color: AppColorConstants.subTitleColor,
                  ),
                ],
              ),
            );
          }),

          // Total Score
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColorConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KText(
                  text: "Total Score:",
                  fontSize: isMobile
                      ? 14
                      : isTablet
                      ? 16
                      : 18,
                  fontWeight: FontWeight.w600,
                  color: AppColorConstants.titleColor,
                ),
                KText(
                  text: "$totalPoints points",
                  fontSize: isMobile
                      ? 14
                      : isTablet
                      ? 16
                      : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    dynamic form,
    SurveyFormSelected selectionState,
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
            List<Map<String, dynamic>> inputForm = [];
            int totalPoints = 0;

            for (int i = 0; i < form.formSection.length; i++) {
              final section = form.formSection[i];
              final id = section.id.toString();
              List<Map<String, String>> formOptions = [];

              // ---------------------------------------------------------
              // SINGLE CHOICE
              // ---------------------------------------------------------
              if (section.chooseType == "single-choice") {
                final selectedIndex = selectionState.singleSelections[i];
                if (selectedIndex != null &&
                    selectedIndex >= 0 &&
                    selectedIndex < section.formOption.length) {
                  final selected = section.formOption[selectedIndex];
                  final points = selected.points?.toString() ?? "0";
                  formOptions.add({
                    "option_name": selected.optionName.toString(),
                    "points": points,
                  });
                  totalPoints += int.tryParse(points) ?? 0;
                }
              }
              // ---------------------------------------------------------
              // MULTIPLE CHOICE
              // ---------------------------------------------------------
              else if (section.chooseType == "multiple-choice") {
                final selectedIndexes = selectionState.multiSelections[i] ?? [];
                for (int idx in selectedIndexes) {
                  if (idx >= 0 && idx < section.formOption.length) {
                    final opt = section.formOption[idx];
                    final points = opt.points?.toString() ?? "0";
                    formOptions.add({
                      "option_name": opt.optionName.toString(),
                      "points": points,
                    });
                    totalPoints += int.tryParse(points) ?? 0;
                  }
                }
              }
              // ---------------------------------------------------------
              // ANSWER TEXT
              // ---------------------------------------------------------
              else if (section.chooseType == "answer") {
                final answer = selectionState.answerTexts[i] ?? "";
                formOptions.add({"option_name": answer, "points": ""});
              }

              // ---------------------------------------------------------
              // Build final object
              // ---------------------------------------------------------
              if (formOptions.isNotEmpty || section.chooseType == "answer") {
                inputForm.add({"id": id, "form_option": formOptions});
              }
            }

            final totalPointsStr = totalPoints.toString();

            AppLoggerHelper.logInfo("Input Form → $inputForm");
            AppLoggerHelper.logInfo("Total Points → $totalPointsStr");

            // Add Survey Operative Form - pass the List<Map<String, dynamic>> directly
            context.read<SurveyOperativeFormBloc>().add(
              AddSurveyOperativeForm(
                userId: userId!,
                operativeFormId: widget.operativeId,
                totalPoints: totalPointsStr,
                inputForm: inputForm,
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
