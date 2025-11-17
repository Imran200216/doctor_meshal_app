import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class KProfileAvatar extends StatelessWidget {
  final double height;
  final double width;
  final String personImageUrl;

  const KProfileAvatar({
    super.key,
    required this.personImageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: personImageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,

        placeholder: (context, url) => Image.asset(
          AppAssetsConstants.personPlaceholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),

        errorWidget: (context, url, error) => Image.asset(
          AppAssetsConstants.personPlaceholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
