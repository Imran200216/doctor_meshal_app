import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

import '../bio.dart';

class BioScreen extends StatelessWidget {
  BioScreen({super.key});

  // ------------------- STATIC BIO DATA -------------------
  final String doctorName =
      "Dr. Meshal Ahmad Alhadhoud MBBCh, SB-Orth, MBA, MPH";

  final String specialization =
      "Orthopaedic Consultant\nOrthopedic Trauma Surgery, "
      "Reconstructive Foot & Ankle Surgery, and Orthopaedic Surgery Research";

  // Academic Certificates & Training
  final List<String> academicCertificates = [
    "Master of Public Health (MPH), Walden University, Minneapolis, Minnesota, United States of America.",
    "Master of Business Administration International Healthcare Management (IHM-MBA), Frankfurt School of Finance and Management.",
    "Orthopedic Foot & Ankle Reconstructive Clinical Research Fellowship, Queen Elizabeth II Hospital, Dalhousie University, Halifax, Canada.",
    "Orthopedic Foot & Ankle Reconstructive Surgery Fellowship, Queen Elizabeth II Hospital, Dalhousie University, Halifax, Canada.",
    "Orthopedic Trauma Surgery Fellowship, King Abdelaziz Medical City, National Guard Hospital, King Saud bin Abdelaziz University for Health Sciences, Riyadh, Saudi Arabia.",
    "Orthopedic Surgery Residency, Saudi Commission for Health Specialties, King Abdelaziz Medical City, National Guard Hospital, Riyadh, Saudi Arabia.",
    "Bachelor of Medicine and Bachelor of Surgery, Cairo University Faculty of Medicine, Cairo, Egypt.",
  ];

  // CV Highlights
  final List<String> cvHighlights = [
    "Evidence-Based Medicine Committee Member in American Orthopedic Foot and Ankle Society (AOFAS).",
    "AO Trauma Faculty Member.",
    "AOPEER Clinical Research Faculty Member.",
    "International OTA Committee Member.",
    "IBRA International Bone Research Association Faculty.",
    "American Orthopedic Foot & Ankle (AOFAS) International Speaker Bureau.",
    "30+ International guest lectures across USA, UK, Switzerland, Germany, Saudi Arabia, Dubai, Egypt, and Italy.",
    "20 peer-reviewed paper publications.",
    "2 textbook chapters.",
  ];

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

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
                backgroundImage: AssetImage(
                  AppAssetsConstants.doctorIntro,
                ),
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
                text: "Academic Certificate & Training",
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
                text: "CV Highlights",
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
