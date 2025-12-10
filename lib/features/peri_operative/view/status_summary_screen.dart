import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/widgets/patient_status_summary_form_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

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

        // Dispatch event to get view submitted form details
        context.read<ViewSubmittedFormDetailsSectionBloc>().add(
          GetViewSubmittedFormDetailsEvent(
            userId: userId!,
            patientFormId: widget.patientFormId,
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
  Widget build(BuildContext context) {
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
          final connectivityState = context.read<ConnectivityBloc>().state;

          // Correct internet check
          if (connectivityState is ConnectivityFailure ||
              (connectivityState is ConnectivitySuccess &&
                  connectivityState.isConnected == false)) {
            KSnackBar.error(context, appLoc.noInternet);
            return;
          }

          await _fetchPatientOperativeSummary();
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
                    // Loading State
                    if (state is GetViewSubmittedFormDetailsSectionLoading) {
                      return ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: 20,
                        itemBuilder: (context, index) => KSkeletonRectangle(),
                      );
                    }

                    // Success State
                    if (state is GetViewSubmittedFormDetailsSectionSuccess) {
                      final submittedForm = state.formDetails;

                      return SingleChildScrollView(
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Form Serial No
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.formSerialNo,
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
                                    "${submittedForm.userId.firstName} ${submittedForm.userId.lastName}",
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

                            const SizedBox(height: 5),

                            // Form Created At
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: submittedForm.createdAtTime,
                              ),
                              hintText: appLoc.formCreatedAt,
                              labelText: appLoc.formCreatedAt,
                            ),

                            const SizedBox(height: 5),

                            // Form Total Points
                            KTextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: "${submittedForm.totalPoints} points",
                              ),
                              hintText: appLoc.formTotalPoints,
                              labelText: appLoc.formTotalPoints,
                            ),

                            const SizedBox(height: 20),

                            PatientStatusSummaryFormCard(
                              submittedForm: submittedForm,
                            ),
                          ],
                        ),
                      );
                    }

                    // Failure State
                    if (state is GetViewSubmittedFormDetailsSectionFailure) {
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
                ),
          ),
        ),
      ),
    );
  }
}
