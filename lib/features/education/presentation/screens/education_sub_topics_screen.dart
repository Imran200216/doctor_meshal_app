import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/education/presentation/widgets/education_sub_topics_card.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class EducationSubTopicsScreen extends StatelessWidget {
  const EducationSubTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.educationSubTopics,
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
        backgroundColor: AppColorConstants.primaryColor,
      ),

      backgroundColor: AppColorConstants.secondaryColor,
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
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return EducationSubTopicsCard(
                  onTap: () {
                    // Education Articles Screen
                    GoRouter.of(
                      context,
                    ).pushNamed(AppRouterConstants.educationArticles);
                  },
                  imageUrl:
                      "https://images.unsplash.com/photo-1624716346723-384d3f9dc2e2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1172",

                  title: "Knee Conditions",
                  noOfArticles: "3",
                );
              },
            )
          : isMobile
          ? ListView.separated(
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
              separatorBuilder: (context, index) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                return EducationSubTopicsCard(
                  onTap: () {
                    // Education Articles Screen
                    GoRouter.of(
                      context,
                    ).pushNamed(AppRouterConstants.educationArticles);
                  },
                  imageUrl:
                      "https://images.unsplash.com/photo-1624716346723-384d3f9dc2e2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1172",
                  title: "Knee Conditions",
                  noOfArticles: "3",
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
