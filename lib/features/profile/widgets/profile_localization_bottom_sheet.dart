import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_bottom_sheet_top_thumb.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/localization/view_model/cubit/localization_cubit.dart';
import 'package:meshal_doctor_booking_app/features/localization/widgets/localization_check_box_list_tile.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ProfileLocalizationBottomSheet extends StatelessWidget {
  const ProfileLocalizationBottomSheet({super.key});

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
        color: AppColorConstants.secondaryColor,
      ),
      child: Column(
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
                      Icons.language_outlined,
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

                // Select Language
                KText(
                  text: appLoc.selectLanguage,
                  fontSize: isMobile
                      ? 22
                      : isTablet
                      ? 24
                      : 26,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.titleColor,
                ),

                const SizedBox(height: 20),

                // Subtitle
                KText(
                  text: appLoc.selectLanguageDescription,
                  fontSize: isMobile
                      ? 17
                      : isTablet
                      ? 19
                      : 21,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  color: AppColorConstants.subTitleColor,
                ),

                const SizedBox(height: 40),

                BlocConsumer<LocalizationCubit, LocalizationState>(
                  listener: (context, state) {
                    if (state is LocalizationSelected) {
                      // Close Bottom Sheet
                      GoRouter.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<LocalizationCubit>();
                    final selectedLang = cubit.selectedLanguage;

                    return Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ✅ English
                        LocalizationCheckBoxListTile(
                          checkBoxTitle: "English",
                          isChecked: selectedLang == "en",
                          onChanged: (bool? value) {
                            cubit.selectLanguage("en");
                            AppLoggerHelper.logInfo(
                              "Selected language: English ✅",
                            );
                          },
                        ),

                        // ✅ Arabic
                        LocalizationCheckBoxListTile(
                          checkBoxTitle: "Arabic",
                          isChecked: selectedLang == "ar",
                          onChanged: (bool? value) {
                            cubit.selectLanguage("ar");
                            AppLoggerHelper.logInfo(
                              "Selected language: Arabic ✅",
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
