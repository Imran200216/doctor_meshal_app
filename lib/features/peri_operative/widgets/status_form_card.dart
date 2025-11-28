import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class StatusCard extends StatelessWidget {
  final String formTitle;
  final String status;
  final String formNo;
  final String formSerialNo;
  final String formType;
  final String formPatientStatus;
  final String doctorStatus;
  final VoidCallback onTap;

  const StatusCard({
    super.key,
    required this.formTitle,
    required this.formNo,
    required this.formSerialNo,
    required this.formType,
    required this.formPatientStatus,
    required this.doctorStatus,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();

          onTap();
        },
        child: Container(
          height: isMobile
              ? 360
              : isTablet
              ? 440
              : 520,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColorConstants.secondaryColor,
            border: Border.all(
              color: AppColorConstants.subTitleColor.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://plus.unsplash.com/premium_photo-1673953510197-0950d951c6d9?q=80&w=2371&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Icon(
                          Icons.image,
                          color: AppColorConstants.subTitleColor.withOpacity(
                            0.3,
                          ),
                          size: isMobile
                              ? 36
                              : isTablet
                              ? 40
                              : 44,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColorConstants.subTitleColor.withOpacity(
                            0.3,
                          ),
                          size: isMobile
                              ? 36
                              : isTablet
                              ? 40
                              : 44,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: AppColorConstants.secondaryColor,
                    child: Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Form
                        DoctorOperativeTextRich(
                          title: appLoc.form,
                          content: formNo,
                        ),

                        // Form Serial No
                        DoctorOperativeTextRich(
                          title: appLoc.formSerialNo,
                          content: formSerialNo,
                        ),

                        // Title
                        DoctorOperativeTextRich(
                          title: appLoc.formTitle,
                          content: formTitle,
                        ),

                        // Patient Status
                        DoctorOperativeTextRich(
                          title: appLoc.patientStatus,
                          content: formPatientStatus,
                        ),

                        // Doctor Status
                        DoctorOperativeTextRich(
                          title: appLoc.doctorStatus,
                          content: doctorStatus,
                        ),

                        // Status
                        DoctorOperativeTextRich(
                          title: appLoc.status,
                          content: status,
                        ),

                        // Form Type
                        DoctorOperativeTextRich(
                          title: appLoc.formType,
                          content: formType == "pre"
                              ? "Pre-Op"
                              : formType == "post"
                              ? "Post-Op"
                              : "",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
