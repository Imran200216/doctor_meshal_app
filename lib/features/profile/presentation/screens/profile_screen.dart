import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/k_text.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';
import 'package:meshal_doctor_booking_app/core/utils/url_launcher_helper.dart';
import 'package:meshal_doctor_booking_app/features/profile/presentation/widgets/profile_details_container.dart';
import 'package:meshal_doctor_booking_app/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:meshal_doctor_booking_app/features/profile/presentation/widgets/profile_log_out_bottom_sheet.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColorConstants.secondaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Directionality(
          textDirection: TextDirection.ltr,
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
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // My Account
                KText(
                  text: appLoc.myAccount,
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

                // Profile
                ProfileDetailsContainer(
                  profileImageUrl:
                      "https://plus.unsplash.com/premium_photo-1672239496290-5061cfee7ebb?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687",
                  name: "John Doe",
                  email: "johndoe@gmail.com",
                ),

                // General
                KText(
                  text: appLoc.general,
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

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColorConstants.subTitleColor.withOpacity(0.05),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      ProfileListTile(
                        prefixIcon: Icons.notes_outlined,
                        title: appLoc.personDetails,
                        onTap: () {
                          // Personal Details Screen
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRouterConstants.personalDetails);
                        },
                      ),

                      ProfileListTile(
                        prefixIcon: Icons.edit_outlined,
                        title: appLoc.editProfile,
                        onTap: () {},
                      ),

                      ProfileListTile(
                        prefixIcon: Icons.language_outlined,
                        title: appLoc.language,
                        onTap: () {},
                      ),

                      ProfileListTile(
                        prefixIcon: Icons.password,
                        title: appLoc.changePassword,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Support
                KText(
                  text: appLoc.support,
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

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColorConstants.subTitleColor.withOpacity(0.05),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      ProfileListTile(
                        prefixIcon: Icons.app_registration,
                        title: appLoc.termsAndConditions,
                        onTap: () {
                          UrlLauncherHelper.launchUrlLink(
                            'https://flutter.dev',
                          );
                        },
                      ),

                      ProfileListTile(
                        prefixIcon: Icons.privacy_tip_outlined,
                        title: appLoc.privacyPolicy,
                        onTap: () {
                          UrlLauncherHelper.launchUrlLink(
                            'https://flutter.dev',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColorConstants.subTitleColor.withOpacity(0.05),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      ProfileListTile(
                        prefixIcon: Icons.logout,
                        title: appLoc.logout,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,

                            builder: (context) {
                              return ProfileLogOutBottomSheet(
                                onCancelTap: () {
                                  // Close Bottom Sheet
                                  GoRouter.of(context).pop();
                                },
                                onSubmitTap: () {
                                  // // Localization
                                  GoRouter.of(
                                    context,
                                  ).goNamed(AppRouterConstants.localization);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
