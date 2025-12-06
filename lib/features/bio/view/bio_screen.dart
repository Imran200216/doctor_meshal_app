import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // ------------------- STATIC BIO DATA -------------------
    final String doctorName = appLoc.doctorBioName;
    final String specialization = appLoc.specialization;

    final String academicTitle = appLoc.academicCertificateTitle;
    final String cvTitle = appLoc.cvHighlightsTitle;


    // Academic Certificates & Training
    final List<String> academicCertificates = [
      appLoc.academicCertificate1,
      appLoc.academicCertificate2,
      appLoc.academicCertificate3,
      appLoc.academicCertificate4,
      appLoc.academicCertificate5,
      appLoc.academicCertificate6,
      appLoc.academicCertificate7,
    ];

    // CV Highlights
    final List<String> cvHighlights = [
      appLoc.cvHighlight1,
      appLoc.cvHighlight2,
      appLoc.cvHighlight3,
      appLoc.cvHighlight4,
      appLoc.cvHighlight5,
      appLoc.cvHighlight6,
      appLoc.cvHighlight7,
      appLoc.cvHighlight8,
      appLoc.cvHighlight9,
    ];

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        centerTitle: true,
        title: appLoc.bio,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              // ------------------- Profile Image -------------------
              CircleAvatar(
                radius: isMobile
                    ? 60
                    : isTablet
                    ? 70
                    : 80,
                backgroundColor: Colors.grey.shade200, // optional
                backgroundImage: AssetImage(AppAssetsConstants.doctorIntro),
              ),

              // ------------------- Name -------------------
              Text(
                doctorName,
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.titleColor,
                  fontSize: isMobile ? 20 : 22,
                ),
              ),

              // ------------------- Specialization -------------------
              Text(
                specialization,
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.w600,
                  color: AppColorConstants.titleColor,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),

              // ------------------- Academic Certificate & Training -------------------
              KText(
                text: academicTitle,
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.primaryColor,
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DoctorBioAcademicCertificateTrainingListTile(
                    academicCertificateAndTrainingTitle:
                    academicCertificates[index],
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemCount: academicCertificates.length,
              ),

              // ------------------- CV Highlights -------------------
              KText(
                text: cvTitle,
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w700,
                color: AppColorConstants.primaryColor,
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DoctorBioAcademicCertificateTrainingListTile(
                    academicCertificateAndTrainingTitle: cvHighlights[index],
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemCount: cvHighlights.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
