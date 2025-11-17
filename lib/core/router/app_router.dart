import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_router_constants.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_change_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_change_password_success_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_forget_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_otp_screen.dart';
import 'package:meshal_doctor_booking_app/features/auth/view/auth_screen.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/view/bottom_nav.dart';
import 'package:meshal_doctor_booking_app/features/change_password/view/change_password_screen.dart';
import 'package:meshal_doctor_booking_app/features/chat/view/chat_list_screen.dart';
import 'package:meshal_doctor_booking_app/features/chat/view/chat_screen.dart';
import 'package:meshal_doctor_booking_app/features/chat/view/doctor_list_screen.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/view/edit_personal_details_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_article_view_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_articles_screen.dart';
import 'package:meshal_doctor_booking_app/features/education/view/education_sub_topics_screen.dart';
import 'package:meshal_doctor_booking_app/features/intro/view/doctor_intro_screen.dart';
import 'package:meshal_doctor_booking_app/features/localization/view/localization_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view/post_op_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view/pre_op_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view/status_screen.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view/survey_form_screen.dart';
import 'package:meshal_doctor_booking_app/features/personal_details/view/personal_details_screen.dart';
import 'package:meshal_doctor_booking_app/features/splash/view/splash_screen.dart';

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
        final extra = state.extra as Map<String, dynamic>? ?? {};

        final message = extra["message"] ?? "";
        final email = extra["email"] ?? "";
        final token = extra["token"] ?? "";

        return AuthOtpScreen(message: message, email: email, token: token);
      },
    ),

    // Auth Change Password Screen
    GoRoute(
      path: '/authChangePassword',
      name: AppRouterConstants.authChangePassword,
      builder: (context, state) {
        // Email
        final email = state.extra as String? ?? '';
        return AuthChangePasswordScreen(email: email);
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
        // Get the passed id from extra
        final educationArticleId = state.extra as String? ?? '';
        return EducationArticlesScreen(educationArticleId: educationArticleId);
      },
    ),

    // Education Articles View Screen
    GoRoute(
      path: '/educationArticlesView',
      name: AppRouterConstants.educationArticlesView,
      builder: (context, state) {
        // Get the passed id from extra
        final educationFullArticleId = state.extra as String? ?? '';
        return EducationArticleViewScreen(
          educationFullArticleId: educationFullArticleId,
        );
      },
    ),

    // Chat List Screen
    GoRoute(
      path: '/chatList',
      name: AppRouterConstants.chatList,
      builder: (context, state) {
        return ChatListScreen();
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

    // Doctor List Screen
    GoRoute(
      path: '/doctorList',
      name: AppRouterConstants.doctorList,
      builder: (context, state) {
        return DoctorListScreen();
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

    // Edit Profile Screen
    GoRoute(
      path: '/editPersonalDetails',
      name: AppRouterConstants.editPersonalDetails,
      builder: (context, state) {
        return EditPersonalDetailsScreen();
      },
    ),

    // Survey Form Screen
    GoRoute(
      path: '/surveyForm',
      name: AppRouterConstants.surveyForm,
      builder: (context, state) {
        // Get the passed id from extra
        final operativeId = state.extra as String? ?? '';
        return SurveyFormScreen(operativeId: operativeId);
      },
    ),
  ],
);
