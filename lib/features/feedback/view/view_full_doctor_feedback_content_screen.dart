import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';

class ViewFullDoctorFeedbackContentScreen extends StatelessWidget {
  final String patientName;
  final String patientSubmittedDate;
  final String patientFeedback;

  const ViewFullDoctorFeedbackContentScreen({
    super.key,
    required this.patientName,
    required this.patientSubmittedDate,
    required this.patientFeedback,
  });

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.viewPatientFeedback,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      backgroundColor: AppColorConstants.secondaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Patient Name
              DoctorOperativeTextRich(
                title: "Patient Name: ",
                content: patientName,
              ),

              // Submitted Date
              DoctorOperativeTextRich(
                title: "Submitted Date",
                content: patientSubmittedDate,
              ),

              // Submitted Date
              DoctorOperativeTextRich(
                title: "Feedback",
                content: patientFeedback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
