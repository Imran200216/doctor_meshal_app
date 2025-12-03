import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class ViewFullDoctorFeedbackContentScreen extends StatefulWidget {
  const ViewFullDoctorFeedbackContentScreen({super.key});

  @override
  State<ViewFullDoctorFeedbackContentScreen> createState() =>
      _ViewFullDoctorFeedbackContentScreenState();
}

class _ViewFullDoctorFeedbackContentScreenState
    extends State<ViewFullDoctorFeedbackContentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

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
                content: "Imran B",
              ),

              // Submitted Date
              DoctorOperativeTextRich(
                title: "Submitted Date",
                content: "22/11/2025",
              ),

              // Submitted Date
              DoctorOperativeTextRich(
                title: "Feedback",
                content: "Good Doctor, his advice make my health more longer",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
