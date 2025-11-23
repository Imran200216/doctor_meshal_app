import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/view_model/bloc/submitted_patient_form_details_section/submitted_patient_form_details_section_bloc.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/widgets/doctor_operative_submitted_form_summary.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/widgets/doctor_operative_text_rich.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

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

  @override
  void initState() {
    _fetchDoctorOperativeSummary();

    super.initState();
  }

  // Fetch Doctor Operative Summary
  Future<void> _fetchDoctorOperativeSummary() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");
        AppLoggerHelper.logInfo("Form ID Passed: ${widget.operativeFormId}");

        // Get Operative Form Events
        context.read<SubmittedPatientFormDetailsSectionBloc>().add(
          GetSubmittedPatientFormDetailsSectionEvent(
            userId: userId!,
            patientFormId: widget.operativeFormId,
          ),
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
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
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
                    if (state is GetSubmittedPatientFormDetailsSectionSuccess) {
                      final submittedForm = state.data;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Form Serial No
                            DoctorOperativeTextRich(
                              title: appLoc.formSerialNo,
                              content: submittedForm.formSerialNo,
                            ),

                            const SizedBox(height: 5),

                            // Title
                            DoctorOperativeTextRich(
                              title: appLoc.formTitle,
                              content: submittedForm.title,
                            ),

                            const SizedBox(height: 5),

                            // Form Type
                            DoctorOperativeTextRich(
                              title: appLoc.formType,
                              content: submittedForm.formType,
                            ),

                            const SizedBox(height: 5),

                            // User Name
                            DoctorOperativeTextRich(
                              title: appLoc.patientName,
                              content:
                                  "${submittedForm.user.firstName} ${submittedForm.user.lastName}",
                            ),

                            const SizedBox(height: 5),

                            // Form Status
                            DoctorOperativeTextRich(
                              title: appLoc.formStatus,
                              content: submittedForm.formStatus,
                            ),

                            const SizedBox(height: 5),

                            // Form Created At
                            DoctorOperativeTextRich(
                              title: appLoc.formCreatedAt,
                              content: submittedForm.createdAtTime,
                            ),

                            const SizedBox(height: 5),

                            // Form Total Points
                            DoctorOperativeTextRich(
                              title: appLoc.formTotalPoints,
                              content: "${submittedForm.totalPoints} points",
                            ),

                            const SizedBox(height: 30),

                            DoctorOperativeSubmittedFormSummary(
                              submittedForm: submittedForm,
                            ),
                          ],
                        ),
                      );
                    } else if (state
                        is GetSubmittedPatientFormDetailsSectionFailure) {
                      AppLoggerHelper.logError("Error: ${state.message}");
                    }

                    return const SizedBox.shrink();
                  },
                ),
          ),
        ),
      ),
    );
  }
}
