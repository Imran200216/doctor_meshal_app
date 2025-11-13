import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_change_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_change_password_success_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_forget_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_otp_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_screen.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/presentation/screens/bottom_nav.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view/change_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_article_view_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_articles_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_sub_topics_screen.dart';
import 'package:meshal_doctor_booking_app/features/intro/presentation/screens/doctor_intro_screen.dart';
import 'package:meshal_doctor_booking_app/features/localization/presentation/screens/localization_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/screens/post_op_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/screens/pre_op_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/screens/status_screen.dart';
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

    // Doctor Intro Screen
    GoRoute(
      path: '/doctorIntro',
      name: AppRouterConstants.doctorIntro,
      builder: (context, state) {
        return DoctorIntroScreen();
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
        // Get the passed id from extra
        final educationId = state.extra as String? ?? '';
        return EducationSubTopicsScreen(educationId: educationId);
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

    // Change Password Screen
    GoRoute(
      path: '/changePassword',
      name: AppRouterConstants.changePassword,
      builder: (context, state) {
        return ChangePasswordScreen();
      },
    ),

    // Pre Op Screen
    GoRoute(
      path: '/preOP',
      name: AppRouterConstants.preOP,
      builder: (context, state) {
        return PreOpScreen();
      },
    ),

    // Post Op Screen
    GoRoute(
      path: '/postOP',
      name: AppRouterConstants.postOP,
      builder: (context, state) {
        return PostOpScreen();
      },
    ),

    // Status Screen
    GoRoute(
      path: '/status',
      name: AppRouterConstants.status,
      builder: (context, state) {
        return StatusScreen();
      },
    ),
  ],
);
