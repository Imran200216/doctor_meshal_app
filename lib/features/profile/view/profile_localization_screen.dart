import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';

class ProfileLocalizationScreen extends StatelessWidget {
  const ProfileLocalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.localization,
        onBack: () {
          // On Back
          GoRouter.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
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
                    //  Back
                    GoRouter.of(context).pop();
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
