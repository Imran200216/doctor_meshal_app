import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';

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

  bool _isLocalFile(String path) {
    if (path.isEmpty || path.trim().isEmpty) return false;

    // Detect only real file system paths
    return path.startsWith('/') || path.startsWith('file://');
  }

  @override
  Widget build(BuildContext context) {
    // If empty → Show placeholder directly
    if (personImageUrl.isEmpty || personImageUrl.trim().isEmpty) {
      return ClipOval(
        child: Image.asset(
          AppAssetsConstants.personPlaceholder,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    final isFile = _isLocalFile(personImageUrl);

    return ClipOval(
      child: isFile
          ? Image.file(
              File(personImageUrl),
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: personImageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholder: (_, __) => Image.asset(
                AppAssetsConstants.personPlaceholder,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
              errorWidget: (_, __, ___) => Image.asset(
                AppAssetsConstants.personPlaceholder,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
