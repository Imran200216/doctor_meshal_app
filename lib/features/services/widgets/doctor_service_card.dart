import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';
import 'package:meshal_doctor_booking_app/features/services/doctor_services.dart';

class DoctorServiceCard extends StatelessWidget {
  final String doctorServiceTitle;
  final String doctorServiceDescription;
  final String doctorServiceImageUrl;

  final List<DoctorServicePoints> doctorServicesList;

  const DoctorServiceCard({
    super.key,
    required this.doctorServiceTitle,
    required this.doctorServiceDescription,
    required this.doctorServiceImageUrl,
    required this.doctorServicesList,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        KText(
          text: doctorServiceTitle,
          fontSize: isMobile
              ? 18
              : isTablet
              ? 20
              : 22,
          fontWeight: FontWeight.w700,
          color: AppColorConstants.titleColor,
        ),

        const SizedBox(height: 20),

        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: doctorServiceImageUrl,
            width: double.maxFinite,
            height: isMobile
                ? 200
                : isTablet
                ? 300
                : 400,
            fit: BoxFit.cover,
            placeholder: (_, __) => Image.asset(
              AppAssetsConstants.imagePlaceholder,
              width: double.maxFinite,
              height: isMobile
                  ? 200
                  : isTablet
                  ? 300
                  : 400,
              fit: BoxFit.cover,
            ),
            errorWidget: (_, __, ___) => Image.asset(
              AppAssetsConstants.imagePlaceholder,
              width: double.maxFinite,
              height: isMobile
                  ? 200
                  : isTablet
                  ? 300
                  : 400,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Description
        KText(
          text: doctorServiceDescription,
          fontSize: isMobile
              ? 15
              : isTablet
              ? 17
              : 19,
          fontWeight: FontWeight.w600,
          color: AppColorConstants.titleColor,
          textAlign: TextAlign.start,
          maxLines: 3,
        ),

        const SizedBox(height: 10),

        // Dynamic list items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctorServicesList.length,
          itemBuilder: (context, index) {
            final service = doctorServicesList[index];
            return DoctorBioAcademicCertificateTrainingListTile(
              academicCertificateAndTrainingTitle: service.title,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
        ),
      ],
    );
  }
}
