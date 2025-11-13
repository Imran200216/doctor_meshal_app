import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/widgets/operative_form_survey_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class PreOpScreen extends StatelessWidget {
  const PreOpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: appLoc.periOperative,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
      ),
      body: isTablet
          ? GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
                vertical: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
              ),
              itemCount: 40,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                return OperativeFormSurveyCard(
                  title: "Book Foot Scale AOFAS",
                  onSurveyTap: () {},
                );
              },
            )
          : isMobile
          ? ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
                vertical: isMobile
                    ? 20
                    : isTablet
                    ? 30
                    : 40,
              ),
              itemBuilder: (context, index) {
                return OperativeFormSurveyCard(
                  title: "Book Foot Scale AOFAS",
                  onSurveyTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
              itemCount: 40,
            )
          : SizedBox.shrink(),
    );
  }
}
