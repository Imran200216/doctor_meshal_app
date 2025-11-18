import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PatientCornerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String noOfArticles;
  final String noOfTopics;
  final VoidCallback onTap;

  const PatientCornerCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.noOfArticles,
    required this.noOfTopics,
    required this.onTap,
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
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          onTap();
        },
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
                // TOP IMAGE
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
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

                // BOTTOM SECTION — FIXED OVERFLOW
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  color: AppColorConstants.secondaryColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // FIX 1
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      KText(
                        text: title,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        fontSize: isMobile
                            ? 20
                            : isTablet
                            ? 22
                            : 24,
                        fontWeight: FontWeight.w700,
                        color: AppColorConstants.titleColor,
                      ),

                      // ROW WITH TOPICS + ARTICLES
                      Row(
                        spacing: 24,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // LEFT SIDE
                          Flexible(
                            child: Row(
                              spacing: 8,
                              children: [
                                SvgPicture.asset(
                                  AppAssetsConstants.subTopics,
                                  height: isMobile
                                      ? 16
                                      : isTablet
                                      ? 18
                                      : 20,
                                  fit: BoxFit.cover,
                                  color: AppColorConstants.primaryColor,
                                ),

                                Flexible(
                                  child: KText(
                                    text: "$noOfTopics ${appLoc.topics}",
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

                          // RIGHT SIDE
                          KText(
                            text: "$noOfArticles ${appLoc.articles}",
                            fontSize: isMobile
                                ? 14
                                : isTablet
                                ? 16
                                : 18,
                            fontWeight: FontWeight.w600,
                            color: AppColorConstants.titleColor,
                          ),
                        ],
                      ),
                    ],
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
