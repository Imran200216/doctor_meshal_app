import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class DoctorOperativeSummaryScreen extends StatefulWidget {
  final String operativeFormId;

  const DoctorOperativeSummaryScreen({
    super.key,
    required this.operativeFormId,
  });

  @override
  State<DoctorOperativeSummaryScreen> createState() =>
      _DoctorOperativeSummaryScreenState();
}

class _DoctorOperativeSummaryScreenState
    extends State<DoctorOperativeSummaryScreen> {
  // User Id
  String? userId;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Controller
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    _fetchDoctorOperativeSummary();
    super.initState();
  }

  // Fetch Doctor Operative Summary
  Future<void> _fetchDoctorOperativeSummary() async {
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

        // Get Operative Form Summary Event
        context.read<SubmittedPatientFormDetailsSectionBloc>().add(
          GetSubmittedPatientFormDetailsSectionEvent(
            userId: userId!,
            patientFormId: widget.operativeFormId,
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
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,

      bottomNavigationBar:
          BlocBuilder<
            SubmittedPatientFormDetailsSectionBloc,
            SubmittedPatientFormDetailsSectionState
          >(
            builder: (context, state) {
              if (state is GetSubmittedPatientFormDetailsSectionSuccess) {
                final submittedForm = state.data;

                // Check if form status is pending (case-insensitive)
                if (submittedForm.formStatus == "Pending") {
                  return Container(
                    height: isMobile
                        ? screenHeight * 0.18
                        : isTablet
                        ? screenHeight * 0.22
                        : screenHeight * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColorConstants.secondaryColor,
                      border: Border(
                        top: BorderSide(
                          color: AppColorConstants.subTitleColor.withOpacity(
                            0.3,
                          ),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Reject Button
                          KFilledBtn(
                            btnTitle: "Reject",
                            onTap: () =>
                                _openRemarksDialog(context, "reject", appLoc),
                            btnBgColor: AppColorConstants.notificationBgColor,
                            btnTitleColor: AppColorConstants.secondaryColor,
                            borderRadius: 12,
                            btnHeight: isMobile
                                ? 50
                                : isTablet
                                ? 52
                                : 54,
                            btnWidth: double.maxFinite,
                            fontSize: isMobile
                                ? 16
                                : isTablet
                                ? 18
                                : 20,
                          ),

                          // Submit Button
                          KFilledBtn(
                            btnTitle: "Submit",
                            onTap: () =>
                                _openRemarksDialog(context, "submit", appLoc),
                            btnBgColor: AppColorConstants.primaryColor,
                            btnTitleColor: AppColorConstants.secondaryColor,
                            borderRadius: 12,
                            btnHeight: isMobile
                                ? 50
                                : isTablet
                                ? 52
                                : 54,
                            btnWidth: double.maxFinite,
                            fontSize: isMobile
                                ? 16
                                : isTablet
                                ? 18
                                : 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }

              // Return null to hide bottom navigation bar if status is not pending
              return const SizedBox.shrink();
            },
          ),

      appBar: KAppBar(
        title: appLoc.operativeSummary,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: RefreshIndicator(
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

          _fetchDoctorOperativeSummary();
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                BlocBuilder<
                  SubmittedPatientFormDetailsSectionBloc,
                  SubmittedPatientFormDetailsSectionState
                >(
                  builder: (context, state) {
                    // Loading State
                    if (state is GetSubmittedPatientFormDetailsSectionLoading) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return KSkeletonTextFormField();
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                        itemCount: 20,
                      );
                    }

                    // Success State
                    if (state is GetSubmittedPatientFormDetailsSectionSuccess) {
                      final submittedForm = state.data;

                      return SingleChildScrollView(
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Form Serial No
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: appLoc.formSerialNo,
                              ),
                              hintText: appLoc.formSerialNo,
                              labelText: appLoc.formSerialNo,
                            ),

                            // Title
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.title,
                              ),
                              hintText: appLoc.formTitle,
                              labelText: appLoc.formTitle,
                            ),

                            // Form Type
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.formType,
                              ),
                              hintText: appLoc.formType,
                              labelText: appLoc.formType,
                            ),

                            // User Name
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text:
                                    "${submittedForm.user.firstName} ${submittedForm.user.lastName}",
                              ),
                              hintText: appLoc.patientName,
                              labelText: appLoc.patientName,
                            ),

                            // Form Status
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.formStatus,
                              ),
                              hintText: appLoc.formStatus,
                              labelText: appLoc.formStatus,
                            ),

                            // Form Created At
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.createdAtTime,
                              ),
                              hintText: appLoc.formCreatedAt,
                              labelText: appLoc.formCreatedAt,
                            ),

                            // Form Total Points
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: "${submittedForm.totalPoints} points",
                              ),
                              hintText: appLoc.formTotalPoints,
                              labelText: appLoc.formTotalPoints,
                            ),

                            const SizedBox(height: 30),

                            KText(
                              text: appLoc.form,
                              fontSize: isMobile
                                  ? 20
                                  : isTablet
                                  ? 22
                                  : 24,
                              fontWeight: FontWeight.w700,
                              color: AppColorConstants.primaryColor,
                            ),

                            DoctorOperativeSubmittedFormSummary(
                              submittedForm: submittedForm,
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      );
                    }

                    // Failure
                    if (state is GetSubmittedPatientFormDetailsSectionFailure) {
                      AppLoggerHelper.logError("Error: ${state.message}");

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
                ),
          ),
        ),
      ),
    );
  }

  void _openRemarksDialog(
    BuildContext context,
    String status,
    AppLocalizations appLoc,
  ) {
    final state = context.read<SubmittedPatientFormDetailsSectionBloc>().state;
    if (state is! GetSubmittedPatientFormDetailsSectionSuccess) return;
    final submittedForm = state.data;
    final String patientId = submittedForm.user.id;

    // Store the router context before opening dialog
    final parentContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocConsumer<
          DoctorReviewPatientSubmittedOperationFormsBloc,
          DoctorReviewPatientSubmittedOperationFormsState
        >(
          listener: (context, reviewState) {
            if (reviewState
                is DoctorReviewPatientSubmittedOperationFormsSuccess) {
              // Close the dialog using dialogContext
              Navigator.of(dialogContext).pop();

              // Use the stable parent context for navigation
              GoRouter.of(parentContext).go(AppRouterConstants.doctorBottomNav);

              // Show success snackbar
              KSnackBar.success(
                parentContext,
                status == "reject"
                    ? "Form rejected successfully!"
                    : "Form submitted successfully!",
              );
            } else if (reviewState
                is DoctorReviewPatientSubmittedOperationFormsFailure) {
              // Close the dialog using dialogContext
              Navigator.of(dialogContext).pop();

              // Use the parent context for snackbar
              KSnackBar.error(parentContext, reviewState.message);
            }
          },
          builder: (context, reviewState) {
            return Form(
              key: _formKey,
              child: RemarksAlertDialog(
                remarksController: remarksController,
                validator: (value) =>
                    AppValidators.empty(context, value, "Enter Remarks"),
                onCancelTap: () => Navigator.of(dialogContext).pop(),
                onSubmitTap: () {
                  // Step 1: Check internet
                  final connectivityState = context
                      .read<ConnectivityBloc>()
                      .state;

                  // Correct internet check
                  if (connectivityState is ConnectivityFailure ||
                      (connectivityState is ConnectivitySuccess &&
                          connectivityState.isConnected == false)) {
                    KSnackBar.error(context, appLoc.noInternet);
                    return;
                  }

                  // Step 2: Validate form
                  if (_formKey.currentState!.validate()) {
                    // Step 3: Prevent duplicate submissions if loading
                    if (reviewState
                        is DoctorReviewPatientSubmittedOperationFormsLoading) {
                      return;
                    }

                    // Step 4: Submit event
                    context
                        .read<DoctorReviewPatientSubmittedOperationFormsBloc>()
                        .add(
                          AddDoctorReviewPatientSubmittedOperationFormsEvent(
                            userId: userId!,
                            patientId: patientId,
                            operativeFormId: widget.operativeFormId,
                            status: status,
                            remarks: remarksController.text.trim(),
                          ),
                        );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
