import 'package:flutter/material.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_bottom_sheet_top_thumb.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_filled_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_outlined_btn.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ProfileLogOutBottomSheet extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onSubmitTap;
  final bool onSubmitLoading;

  const ProfileLogOutBottomSheet({
    super.key,
    required this.onCancelTap,
    required this.onSubmitTap, required this.onSubmitLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Bottom Sheet Top Thumb
          KBottomSheetTopThumb(),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: AppColorConstants.primaryColor,
                  radius: isMobile
                      ? 55
                      : isTablet
                      ? 60
                      : 65,
                  child: Center(
                    child: Icon(
                      Icons.logout,
                      color: AppColorConstants.secondaryColor,
                      size: isMobile
                          ? 50
                          : isTablet
                          ? 55
                          : 60,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
                KText(
                  text: appLoc.logoutConfirmation,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  fontSize: isMobile
                      ? 20
                      : isTablet
                      ? 22
                      : 24,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.titleColor,
                ),

                const SizedBox(height: 14),

                // Sub Title
                KText(
                  text: appLoc.logoutConfirmationDescription,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  fontSize: isMobile
                      ? 16
                      : isTablet
                      ? 18
                      : 20,
                  fontWeight: FontWeight.w500,
                  color: AppColorConstants.subTitleColor,
                ),

                const SizedBox(height: 30),

                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Cancel Btn
                    Expanded(
                      child: KOutlinedBtn(
                        btnTitle: appLoc.cancel,
                        onTap: () {
                          onCancelTap();
                        },
                        borderRadius: 12,
                        fontSize: 16,
                        btnHeight: 48,
                        btnWidth: double.infinity,
                      ),
                    ),

                    // Logout Btn
                    Expanded(
                      child: KFilledBtn(
                        isLoading: onSubmitLoading,
                        btnTitle: appLoc.logout,
                        btnBgColor: AppColorConstants.primaryColor,
                        btnTitleColor: AppColorConstants.secondaryColor,
                        onTap: () {
                          onSubmitTap();
                        },
                        borderRadius: 12,
                        fontSize: isMobile
                            ? 16
                            : isTablet
                            ? 18
                            : 20,
                        btnHeight: isMobile
                            ? 50
                            : isTablet
                            ? 52
                            : 54,
                        btnWidth: double.maxFinite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
