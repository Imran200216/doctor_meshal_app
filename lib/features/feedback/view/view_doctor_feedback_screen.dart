import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';

class ViewDoctorFeedbackScreen extends StatefulWidget {
  const ViewDoctorFeedbackScreen({super.key});

  @override
  State<ViewDoctorFeedbackScreen> createState() =>
      _ViewDoctorFeedbackScreenState();
}

class _ViewDoctorFeedbackScreenState extends State<ViewDoctorFeedbackScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.patientFeedbacks,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return FeedbackListTile(
            patientName: "Imran B",
            patientImageUrl:
                "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            feedbackDateSubmitted: "22/11/2025",
            onTap: () {
              // View Full Doctor Feedback Content Screen
              GoRouter.of(
                context,
              ).pushNamed(AppRouterConstants.viewFullDoctorFeedbackContent);
            },
            patientFeedbackContent:
                "Good Doctor, His Advice make my health more longer",
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            color: AppColorConstants.subTitleColor.withOpacity(0.2),
          );
        },
        itemCount: 30,
      ),
    );
  }
}
