import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text_rich.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class DoctorOperativeTextRich extends StatelessWidget {
  final String title;
  final String content;

  const DoctorOperativeTextRich({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return KTextRich(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      children: [
        TextSpan(
          text: "$title: ",
          style: TextStyle(
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            fontWeight: FontWeight.w700,
            color: AppColorConstants.titleColor,
          ),
        ),
        TextSpan(
          text: content,
          style: TextStyle(
            fontSize: isMobile
                ? 16
                : isTablet
                ? 18
                : 20,
            fontWeight: FontWeight.w500,
            color: AppColorConstants.titleColor,
          ),
        ),
      ],
    );
  }
}
