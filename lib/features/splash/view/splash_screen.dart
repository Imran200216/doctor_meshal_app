import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

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
        // Get user model map from Hive
        final storedUserMap = await HiveService.getData<Map>(
          boxName: AppDBConstants.userBox,
          key: AppDBConstants.userAuthData,
        );

        if (storedUserMap == null) {
          AppLoggerHelper.logInfo("No user model found → navigate to login");
          GoRouter.of(
            context,
          ).pushReplacementNamed(AppRouterConstants.localization);
          return;
        }

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(
          Map<String, dynamic>.from(storedUserMap),
        );

        final userType = storedUser.userType;

        AppLoggerHelper.logInfo(
          "Extracted userType from Hive model: $userType",
        );

        // Navigate based on userType
        if (userType == 'doctor' || userType == 'admin') {
          GoRouter.of(
            context,
          ).pushReplacementNamed(AppRouterConstants.doctorBottomNav);
        } else {
          GoRouter.of(
            context,
          ).pushReplacementNamed(AppRouterConstants.patientBottomNav);
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
              ? 180
              : isTablet
              ? 200
              : 220,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
