import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class BioScreen extends StatelessWidget {
  const BioScreen({super.key});

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
        centerTitle: true,
        title: appLoc.bio,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),

      body: RefreshIndicator(
        color: AppColorConstants.secondaryColor,
        backgroundColor: AppColorConstants.primaryColor,
        onRefresh: () async {},
        child: SingleChildScrollView(
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
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                // Profile Avatar
                KProfileAvatar(
                  personImageUrl:
                      "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  height: isMobile
                      ? 90
                      : isTablet
                      ? 100
                      : 100,
                  width: isMobile
                      ? 90
                      : isTablet
                      ? 100
                      : 100,
                ),

                // Name & Designation
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: Text("Dr. Meshal Ahmad Alhadhoud"),
                  titleTextStyle: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.titleColor,
                    fontSize: isMobile
                        ? 18
                        : isTablet
                        ? 20
                        : 22,
                  ),

                  subtitle: Text(
                    "MBBCH, SB-Orth, MDA, MPH Orthopaedic Consultant",
                  ),
                  subtitleTextStyle: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w600,
                    color: AppColorConstants.titleColor,
                    fontSize: isMobile
                        ? 16
                        : isTablet
                        ? 18
                        : 20,
                  ),
                ),

                // Academic Certificate & Training
                KText(
                  text: "Academic Certificate & Training",
                  fontSize: isMobile
                      ? 18
                      : isTablet
                      ? 20
                      : 22,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.primaryColor,
                ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DoctorBioAcademicCertificateTrainingListTile(
                      academicCertificateAndTrainingTitle:
                          "Master of Medicine in Orthopedics (MMO) in United States",
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemCount: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
