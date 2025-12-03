import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

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
            fontFamily: "OpenSans",
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
            fontFamily: "OpenSans",
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
