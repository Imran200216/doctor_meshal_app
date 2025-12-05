import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  // App Version
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "V ${info.version}";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    // Localization
    final appLoc = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: AppColorConstants.secondaryColor,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            color: AppColorConstants.primaryColor,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: screenHeight * 0.03,
            ),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Image.asset(
                    AppAssetsConstants.splashLogo,
                    height: isMobile
                        ? 100
                        : isTablet
                        ? 120
                        : 140,
                    fit: BoxFit.cover,
                  ),
                ),

                KText(
                  text: appLoc.meshalApp,
                  fontSize: isMobile
                      ? 20
                      : isTablet
                      ? 22
                      : 24,
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.secondaryColor,
                ),
              ],
            ),
          ),

          // Bio
          HomeDrawerListTile(
            homeListTitle: appLoc.bio,
            homeListTitleTap: () {
              // Doctor Bio Screen
              GoRouter.of(context).pushNamed(AppRouterConstants.bio);
            },
            iconData: Icons.description_outlined,
          ),

          SizedBox(height: 3),

          // Service
          HomeDrawerListTile(
            homeListTitle: appLoc.services,
            homeListTitleTap: () {
              // Doctor Services Screen
              GoRouter.of(context).pushNamed(AppRouterConstants.doctorServices);
            },
            iconData: Icons.health_and_safety_outlined,
          ),

          const Spacer(),

          // App Version at the bottom
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: KText(
              text: appVersion,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
              fontWeight: FontWeight.w600,
              color: AppColorConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
