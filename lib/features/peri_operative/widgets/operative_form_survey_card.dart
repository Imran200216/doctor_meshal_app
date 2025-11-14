import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class OperativeFormSurveyCard extends StatelessWidget {
  final String title;
  final VoidCallback onSurveyTap;
  final bool isFormEnabled;

  const OperativeFormSurveyCard({
    super.key,
    required this.title,
    required this.onSurveyTap,
    this.isFormEnabled = false,
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
      child: Container(
        height: isMobile
            ? 250
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
                        color: AppColorConstants.subTitleColor.withOpacity(0.3),
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
                        color: AppColorConstants.subTitleColor.withOpacity(0.3),
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
                  child: Row(
                    spacing: 30,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Title
                            KText(
                              text: title,
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

                            // Open Survey
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                onSurveyTap();
                              },
                              child: KText(
                                text: appLoc.openSurvey,
                                textAlign: TextAlign.start,
                                textDecoration: TextDecoration.underline,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                fontSize: isMobile
                                    ? 14
                                    : isTablet
                                    ? 16
                                    : 18,
                                fontWeight: FontWeight.w600,
                                color: AppColorConstants.titleColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      isFormEnabled
                          ? Icon(
                              Icons.lock,
                              size: isMobile
                                  ? 30
                                  : isTablet
                                  ? 40
                                  : 50,
                              color: AppColorConstants.primaryColor,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
