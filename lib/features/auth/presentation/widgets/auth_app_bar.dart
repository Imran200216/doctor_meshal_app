import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackTap;

  const AuthAppBar({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: AppColorConstants.secondaryColor,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            // Navigate back
            onBackTap();
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: AppColorConstants.titleColor,
          ),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
