import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_assets_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_color_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_db_constants.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/hive_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/core/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthAndNavigate();
  }

  // Check Auth and Navigate
  Future<void> _checkAuthAndNavigate() async {
    try {
      // Wait for splash duration
      await Future.delayed(const Duration(seconds: 3));

      // Open Hive box
      AppLoggerHelper.logInfo("Opening Hive box to check auth status");
      await HiveService.openBox(AppDBConstants.userBox);

      // Get logged status
      final isLoggedIn =
          await HiveService.getData(
            boxName: AppDBConstants.userBox,
            key: AppDBConstants.userAuthLoggedStatus,
          ) ??
          false;

      AppLoggerHelper.logInfo("User logged status: $isLoggedIn");

      if (!mounted) return;

      if (isLoggedIn) {
        // Get user type
        final userType = await HiveService.getData(
          boxName: AppDBConstants.userBox,
          key: AppDBConstants.userAuthLoggedType,
        );

        AppLoggerHelper.logInfo("User type: $userType");

        // Navigate based on user type
        if (userType == 'doctor') {
          AppLoggerHelper.logInfo("Navigating to Doctor Bottom Nav");
          GoRouter.of(
            context,
          ).pushReplacementNamed(AppRouterConstants.doctorBottomNav);
        } else {
          // Default to patient bottom nav for 'patient' or null/unknown types
          AppLoggerHelper.logInfo("Navigating to Patient Bottom Nav");
          GoRouter.of(
            context,
          ).pushReplacementNamed(AppRouterConstants.bottomNav);
        }
      } else {
        // User not logged in, navigate to localization
        AppLoggerHelper.logInfo(
          "User not logged in, navigating to Localization",
        );
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouterConstants.localization);
      }
    } catch (e) {
      AppLoggerHelper.logError("Error checking auth status: $e");

      // On error, navigate to localization as fallback
      if (mounted) {
        GoRouter.of(
          context,
        ).pushReplacementNamed(AppRouterConstants.localization);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColorConstants.primaryColor,

      body: Center(
        child: Image.asset(
          AppAssetsConstants.splashLogo,
          height: isMobile
              ? 150
              : isTablet
              ? 180
              : 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
