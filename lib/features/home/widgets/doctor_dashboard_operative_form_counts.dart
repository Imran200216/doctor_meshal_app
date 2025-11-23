import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/widgets/doctor_operative_text_rich.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class DoctorDashboardOperativeFormCounts extends StatelessWidget {
  final String formName;
  final String submittedCounts;
  final String reSubmittedCounts;
  final String reviewedCounts;
  final String approvedCounts;
  final String rejectedCounts;

  const DoctorDashboardOperativeFormCounts({
    super.key,
    required this.formName,
    required this.submittedCounts,
    required this.reSubmittedCounts,
    required this.reviewedCounts,
    required this.approvedCounts,
    required this.rejectedCounts,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColorConstants.secondaryColor,
          border: Border.all(
            color: AppColorConstants.subTitleColor.withOpacity(0.2),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColorConstants.primaryColor,
              ),
              child: Center(
                child: Icon(
                  Icons.speaker_notes,
                  size: isMobile
                      ? 28
                      : isTablet
                      ? 30
                      : 32,
                  color: AppColorConstants.secondaryColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Submitted Counts
            DoctorOperativeTextRich(title: appLoc.form, content: formName),

            const SizedBox(height: 5),

            // Submitted Counts
            DoctorOperativeTextRich(
              title: appLoc.submittedCounts,
              content: submittedCounts,
            ),

            const SizedBox(height: 5),

            // ReSubmitted Counts
            DoctorOperativeTextRich(
              title: appLoc.reSubmittedCounts,
              content: reSubmittedCounts,
            ),

            const SizedBox(height: 5),

            // Reviewed Counts
            DoctorOperativeTextRich(
              title: appLoc.reviewedCounts,
              content: reviewedCounts,
            ),

            const SizedBox(height: 5),

            // Approved Counts
            DoctorOperativeTextRich(
              title: appLoc.approvedCounts,
              content: approvedCounts,
            ),

            const SizedBox(height: 5),

            // Rejected Counts
            DoctorOperativeTextRich(
              title: appLoc.rejectedCounts,
              content: rejectedCounts,
            ),
          ],
        ),
      ),
    );
  }
}
