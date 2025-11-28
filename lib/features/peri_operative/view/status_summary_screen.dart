import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/widgets/patient_status_summary_form_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';

class StatusSummaryScreen extends StatefulWidget {
  final String patientFormId;

  const StatusSummaryScreen({super.key, required this.patientFormId});

  @override
  State<StatusSummaryScreen> createState() => _StatusSummaryScreenState();
}

class _StatusSummaryScreenState extends State<StatusSummaryScreen> {
  // User Id
  String? userId;

  @override
  void initState() {
    // Fetch Patient Operative Summary
    _fetchPatientOperativeSummary();
    super.initState();
  }

  // Fetch Patient Operative Summary
  Future<void> _fetchPatientOperativeSummary() async {
    try {
      await HiveService.openBox(AppDBConstants.userBox);

      final storedUserId = await HiveService.getData<String>(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userId,
      );

      if (storedUserId != null) {
        userId = storedUserId;

        AppLoggerHelper.logInfo("User ID fetched: $userId");
        AppLoggerHelper.logInfo("Form ID Passed: ${widget.patientFormId}");

        // Get View Submitted Form Details Event
        context.read<ViewSubmittedFormDetailsSectionBloc>().add(
          GetViewSubmittedFormDetailsEvent(
            userId: userId!,
            patientFormId: widget.patientFormId,
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
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;


    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,

      appBar: KAppBar(
        title: "Status Summary",
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),

      body: RefreshIndicator(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {
          _fetchPatientOperativeSummary();
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:
                BlocBuilder<
                  ViewSubmittedFormDetailsSectionBloc,
                  ViewSubmittedFormDetailsSectionState
                >(
                  builder: (context, state) {
                    if (state is GetViewSubmittedFormDetailsSectionSuccess) {
                      final submittedForm = state.formDetails;

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
                                  "${submittedForm.userId.firstName} ${submittedForm.userId.lastName}",
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

                            PatientStatusSummaryFormCard(
                              submittedForm: submittedForm,
                            ),
                          ],
                        ),
                      );
                    } else if (state
                        is GetViewSubmittedFormDetailsSectionFailure) {
                      AppLoggerHelper.logError("Error: ${state.message}");

                      return Center(
                        child: KNoItemsFound(
                          noItemsFoundText: appLoc.somethingWentWrong,
                          noItemsSvg: AppAssetsConstants.failure,
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
}
