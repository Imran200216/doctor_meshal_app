import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

class FeedbackListTile extends StatelessWidget {
  final String patientName;
  final String patientImageUrl;
  final String feedbackDateSubmitted;
  final String patientFeedbackContent;
  final VoidCallback onTap;

  const FeedbackListTile({
    super.key,
    required this.patientName,
    required this.patientImageUrl,
    required this.feedbackDateSubmitted,
    required this.onTap,
    required this.patientFeedbackContent,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ListTile(
      splashColor: AppColorConstants.transparentColor,
      hoverColor: AppColorConstants.transparentColor,
      focusColor: AppColorConstants.transparentColor,
      tileColor: AppColorConstants.transparentColor,

      onTap: () {
        // View Full Doctor Feedback Content Screen
        HapticFeedback.heavyImpact();
        onTap();
      },

      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      leading: CachedNetworkImage(
        imageUrl: patientImageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 25,
          backgroundColor: AppColorConstants.subTitleColor,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 25,
          backgroundColor: AppColorConstants.subTitleColor.withOpacity(0.2),
          child: Icon(Icons.person, color: Colors.white),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 25,
          backgroundColor: AppColorConstants.subTitleColor.withOpacity(0.2),
          child: Icon(Icons.error, color: Colors.white),
        ),
      ),

      trailing: KText(
        text: feedbackDateSubmitted,
        fontSize: isMobile
            ? 14
            : isTablet
            ? 16
            : 18,
        fontWeight: FontWeight.w600,
        color: AppColorConstants.primaryColor,
        textAlign: TextAlign.center,
        softWrap: true,
        maxLines: 2,
      ),

      title: Text(patientName),
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
        patientFeedbackContent,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      subtitleTextStyle: TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w500,
        color: AppColorConstants.subTitleColor,
        fontSize: isMobile
            ? 16
            : isTablet
            ? 18
            : 20,
      ),
    );
  }
}
