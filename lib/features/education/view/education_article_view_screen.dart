import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_app_bar.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class EducationArticleViewScreen extends StatelessWidget {
  const EducationArticleViewScreen({super.key});

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
        title: "ALC Injuries",
        onBack: () {
          // Back
          GoRouter.of(context).pop();
        },
        backgroundColor: AppColorConstants.primaryColor,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
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
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Topics
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${appLoc.topics}: ",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile
                              ? 18
                              : isTablet
                              ? 20
                              : 22,
                          color: AppColorConstants.titleColor,
                        ),
                      ),
                      TextSpan(
                        text: "ACL Injuries",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile
                              ? 18
                              : isTablet
                              ? 20
                              : 22,
                          color: AppColorConstants.subTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SubTopics
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${appLoc.subTopics}: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isMobile
                              ? 18
                              : isTablet
                              ? 20
                              : 22,
                          color: AppColorConstants.titleColor,
                        ),
                      ),
                      TextSpan(
                        text: "Pharmacy",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile
                              ? 18
                              : isTablet
                              ? 20
                              : 22,
                          color: AppColorConstants.subTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),


                // Article
                KText(
                  text: appLoc.articles,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  fontSize: isMobile
                      ? 18
                      : isTablet
                      ? 20
                      : 22,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.titleColor,
                ),

                const SizedBox(height: 20),


                // Articles
                KText(
                  text:
                      "The anterior cruciate ligament (ACL) is one of the key ligaments that help stabilize your knee joint. Injuries to the ACL are common among athletes and can occur during sudden stops, changes in direction, or improper landings.\n\n"
                      "An ACL tear often causes pain, swelling, and difficulty bearing weight on the affected leg. Early diagnosis through imaging tests like MRI is crucial for effective treatment and recovery.\n\n"
                      "Treatment options may include physical therapy, bracing, or surgical reconstruction depending on the severity of the injury and the patient’s activity level. Proper rehabilitation helps restore strength and stability to the knee.\n\n"
                      "Rehabilitation after ACL surgery focuses on regaining full motion, rebuilding muscle strength, and improving balance. The process can take several months and requires dedication to physiotherapy exercises.\n\n"
                      "Preventing ACL injuries involves proper warm-up, strength training, and improving coordination. Exercises that focus on strengthening the core and lower body can significantly reduce the risk of ligament tears.\n\n"
                      "Athletes returning to sports after ACL injury must undergo specific functional tests to ensure that their knee has regained adequate stability and strength. Returning too early increases the risk of re-injury.\n\n"
                      "Women are statistically more prone to ACL injuries due to anatomical and hormonal differences. Sports programs that emphasize safe landing mechanics and balance training are particularly important for female athletes.\n\n"
                      "Modern surgical techniques and improved rehabilitation protocols have increased the success rate of ACL reconstructions. With proper care, most patients can return to their regular physical activities within 6 to 9 months.\n\n"
                      "Long-term outcomes depend on following a well-structured recovery plan and avoiding high-impact movements until the ligament fully heals. Continuous strengthening and flexibility exercises help maintain knee health.",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.visible,
                  fontSize: isMobile
                      ? 16
                      : isTablet
                      ? 18
                      : 20,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: AppColorConstants.subTitleColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
