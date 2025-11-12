import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/screens/auth_change_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/screens/auth_change_password_success_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/screens/auth_forget_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/screens/auth_otp_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/presentation/screens/bottom_nav.dart';
import 'package:meshal_doctor_booking_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/presentation/screens/education_article_view_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/presentation/screens/education_articles_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/presentation/screens/education_sub_topics_screen.dart';
import 'package:meshal_doctor_booking_app/features/localization/presentation/screens/localization_screen.dart';
import 'package:meshal_doctor_booking_app/features/personal_details/presentation/screens/personal_details_screen.dart';
import 'package:meshal_doctor_booking_app/features/splash/presentation/screens/splash_screen.dart';

GoRouter appRouter = GoRouter(
  initialLocation: "/splash",

  routes: [
    // Splash Screen
    GoRoute(
      path: '/splash',
      name: AppRouterConstants.splash,
      builder: (context, state) {
        return SplashScreen();
      },
    ),

    // Localization Screen
    GoRoute(
      path: '/localization',
      name: AppRouterConstants.localization,
      builder: (context, state) {
        return LocalizationScreen();
      },
    ),

    // Auth Screen
    GoRoute(
      path: '/auth',
      name: AppRouterConstants.auth,
      builder: (context, state) {
        return AuthScreen();
      },
    ),

    // Auth Forget Password Screen
    GoRoute(
      path: '/authForgetPassword',
      name: AppRouterConstants.authForgetPassword,
      builder: (context, state) {
        return AuthForgetPasswordScreen();
      },
    ),

    // Auth OTP Screen
    GoRoute(
      path: '/authOTP',
      name: AppRouterConstants.authOTP,
      builder: (context, state) {
        return AuthOtpScreen();
      },
    ),

    // Auth Change Password Screen
    GoRoute(
      path: '/authChangePassword',
      name: AppRouterConstants.authChangePassword,
      builder: (context, state) {
        return AuthChangePasswordScreen();
      },
    ),

    // Auth Change Password Success Screen
    GoRoute(
      path: '/authChangePasswordSuccess',
      name: AppRouterConstants.authChangePasswordSuccess,
      builder: (context, state) {
        return AuthChangePasswordSuccessScreen();
      },
    ),

    // Bottom Nav
    GoRoute(
      path: '/bottomNav',
      name: AppRouterConstants.bottomNav,
      builder: (context, state) {
        return BottomNav();
      },
    ),

    // Education Sub Topics Screen
    GoRoute(
      path: '/educationSubTopics',
      name: AppRouterConstants.educationSubTopics,
      builder: (context, state) {
        return EducationSubTopicsScreen();
      },
    ),

    // Education Articles Screen
    GoRoute(
      path: '/educationArticles',
      name: AppRouterConstants.educationArticles,
      builder: (context, state) {
        return EducationArticlesScreen();
      },
    ),

    // Education Articles View Screen
    GoRoute(
      path: '/educationArticlesView',
      name: AppRouterConstants.educationArticlesView,
      builder: (context, state) {
        return EducationArticleViewScreen();
      },
    ),

    // Chat Screen
    GoRoute(
      path: '/chat',
      name: AppRouterConstants.chat,
      builder: (context, state) {
        return ChatScreen();
      },
    ),

    // Personal Details Screen
    GoRoute(
      path: '/personalDetails',
      name: AppRouterConstants.personalDetails,
      builder: (context, state) {
        return PersonalDetailsScreen();
      },
    ),
  ],
);
