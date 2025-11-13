import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class EducationArticleCard extends StatelessWidget {
  final VoidCallback onTap;
  final String educationArticleName;

  const EducationArticleCard({
    super.key,
    required this.onTap,
    required this.educationArticleName,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColorConstants.subTitleColor.withOpacity(0.2),
            // 🔹 Border color
            width: 0.8,
          ),
        ),
        elevation: 0, // 🔹 No shadow, flat look
        color: Colors.transparent, // 🔹 No background color
        child: ListTile(
          onTap: (){
            HapticFeedback.heavyImpact();

            onTap();

          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: AppColorConstants.primaryColor,
            radius: isMobile
                ? 30
                : isTablet
                ? 34
                : 38,
            child: Center(
              child: SvgPicture.asset(
                AppAssetsConstants.subTopics,
                height: isMobile
                    ? 22
                    : isTablet
                    ? 24
                    : 26,
                fit: BoxFit.cover,
                color: AppColorConstants.secondaryColor,
              ),
            ),
          ),
          title: Text(
           educationArticleName,
            style: TextStyle(
              fontSize: isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: AppColorConstants.titleColor,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColorConstants.primaryColor,
            size: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
          ),
        ),
      ),
    );
  }
}
