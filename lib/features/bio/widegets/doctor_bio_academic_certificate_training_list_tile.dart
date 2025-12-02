import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

class DoctorBioAcademicCertificateTrainingListTile extends StatelessWidget {
  final String academicCertificateAndTrainingTitle;

  const DoctorBioAcademicCertificateTrainingListTile({
    super.key,
    required this.academicCertificateAndTrainingTitle,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ListTile(
      leading: Icon(
        Icons.control_point_duplicate_sharp,
        color: AppColorConstants.primaryColor,
      ),
      title: Text(academicCertificateAndTrainingTitle),
      titleTextStyle: TextStyle(
        fontFamily: "OpenSans",
        fontWeight: FontWeight.w600,
        color: AppColorConstants.titleColor,
        fontSize: isMobile
            ? 14
            : isTablet
            ? 16
            : 18,
      ),
    );
  }
}
