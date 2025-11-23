import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class DoctorOperativeFormCard extends StatelessWidget {
  final String formTitle;
  final String patientName;
  final String formStatusSubmitted;
  final String formSubmittedDate;
  final VoidCallback onTap;

  const DoctorOperativeFormCard({
    super.key,
    required this.formTitle,
    required this.patientName,
    required this.formStatusSubmitted,
    required this.formSubmittedDate,
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
              ? 400
              : isTablet
              ? 300
              : 400,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Title
                        KText(
                          text: formTitle,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          fontSize: isMobile
                              ? 18
                              : isTablet
                              ? 20
                              : 22,
                          fontWeight: FontWeight.w700,
                          color: AppColorConstants.titleColor,
                        ),

                        const SizedBox(height: 8),

                        // Patient Name
                        KText(
                          text: "${appLoc.patientName}: $patientName",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          fontSize: isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColorConstants.titleColor,
                        ),

                        // Form Status
                        KText(
                          text: "${appLoc.formStatus}: $formStatusSubmitted",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          fontSize: isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColorConstants.titleColor,
                        ),

                        // Submitted Date
                        KText(
                          text: "${appLoc.submittedDate}: $formSubmittedDate",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          fontSize: isMobile
                              ? 16
                              : isTablet
                              ? 18
                              : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColorConstants.titleColor,
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
