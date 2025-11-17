import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/localization/view_model/cubit/localization_cubit.dart';
import 'package:meshal_doctor_booking_app/features/localization/widgets/localization_check_box_list_tile.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class LocalizationScreen extends StatelessWidget {
  const LocalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 30
                : isTablet
                ? 40
                : 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Svg
              SvgPicture.asset(
                AppAssetsConstants.localization,
                height: isMobile
                    ? 200
                    : isTablet
                    ? 220
                    : 240,
                fit: BoxFit.cover,
                color: AppColorConstants.primaryColor,
              ),

              const SizedBox(height: 40),

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
                    // Doctor Intro Screen
                    GoRouter.of(
                      context,
                    ).pushReplacementNamed(AppRouterConstants.doctorIntro);
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<LocalizationCubit>();
                  final selectedLang = cubit.selectedLanguage;

                  return Padding(
                    padding: isTablet
                        ? EdgeInsets.symmetric(horizontal: 100)
                        : isMobile
                        ? EdgeInsets.symmetric()
                        : EdgeInsets.symmetric(),
                    child: Column(
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
