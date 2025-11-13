import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/features/education/widgets/education_article_card.dart';

class EducationArticlesScreen extends StatelessWidget {
  const EducationArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      appBar: KAppBar(
        title: "ALC Injuries",
        description: "Knee Conditioned Injure",
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
        backgroundColor: AppColorConstants.primaryColor,
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
                childAspectRatio: 5,
              ),
              itemBuilder: (context, index) {
                return EducationArticleCard(
                  onTap: () {
                    // Education Article View Screen
                    GoRouter.of(
                      context,
                    ).pushNamed(AppRouterConstants.educationArticlesView);
                  },
                  educationArticleName:
                      "Understanding ACL Tears: Causes and Symptoms",
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
                return EducationArticleCard(
                  onTap: () {
                    // Education Article View Screen
                    GoRouter.of(
                      context,
                    ).pushNamed(AppRouterConstants.educationArticlesView);
                  },
                  educationArticleName:
                      "Understanding ACL Tears: Causes and Symptoms",
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
