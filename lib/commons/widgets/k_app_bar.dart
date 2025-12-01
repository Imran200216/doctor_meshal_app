import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';


class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? description;
  final VoidCallback? onBack;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  final Widget? trailing; // 👈 NEW OPTIONAL TRAILING

  const KAppBar({
    super.key,
    required this.title,
    this.description,
    this.onBack,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.fontSize,
    this.fontWeight,
    this.trailing, // 👈 add to constructor
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    final titleWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
      centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.w700,
            color: titleColor ?? AppColorConstants.secondaryColor,
            fontFamily: "OpenSans",
            fontSize: fontSize ??
                (isMobile
                    ? 18
                    : isTablet
                    ? 20
                    : 22),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: TextStyle(
              color: AppColorConstants.secondaryColor.withOpacity(0.9),
              fontFamily: "OpenSans",
              fontSize: fontSize != null
                  ? fontSize! - 4
                  : (isMobile
                  ? 14
                  : isTablet
                  ? 16
                  : 18),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        automaticallyImplyLeading: false,
        title: titleWidget,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? AppColorConstants.primaryColor,

        // 👇 LEADING (BACK BUTTON)
        leading: IconButton(
          onPressed: onBack ?? () => Navigator.pop(context),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: AppColorConstants.secondaryColor,
          ),
        ),

        // 👇 OPTIONAL TRAILING
        actions: trailing != null ? [trailing!] : null,

        toolbarHeight: description != null ? 90 : kToolbarHeight,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(description != null ? 90 : kToolbarHeight);
}
