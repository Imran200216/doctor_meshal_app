import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/bloc/core_injection.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_api_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth_injection.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav_injection.dart';
import 'package:meshal_doctor_booking_app/features/change_password/change_password_injection.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat_injection.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative_injection.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/edit_profile_details_injection.dart';
import 'package:meshal_doctor_booking_app/features/education/education_injection.dart';
import 'package:meshal_doctor_booking_app/features/home/home_injection.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization_injection.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative_injection.dart';

final GetIt getIt = GetIt.instance;

void setUpServiceLocators() {
  // Graphql Service
  getIt.registerSingletonAsync<GraphQLService>(() async {
    final service = GraphQLService();
    await service.init(httpEndpoint: AppApiConstants.baseUrl);
    return service;
  });

  // Chat Graphql Service
  getIt.registerSingletonAsync<ChatGraphQLHttpService>(() async {
    final service = ChatGraphQLHttpService();

    await service.init(
      httpEndpoint: AppApiConstants.chatBaseUrl,
      websocketEndpoint: AppApiConstants.webSocketUrl,
    );

    return service;
  });

  // Core Injection
  initCoreInjection();

  // Localization Injection
  initLocalizationInjection();

  // Auth Injection
  initAuthInjection();

  // Bottom Nav Injection
  initBottomNavInjection();

  // Patient Peri Operative Injection
  initPeriOperativeInjection();

  // Doctor Peri Operative Injection
  initDoctorPeriOperativeInjection();

  // Education Injection
  initEducationInjection();

  // Change Password Injection
  initChangePasswordInjection();

  // Edit Profile Injection
  initEditProfileDetailsInjection();

  // Chat Injection
  initChatInjection();

  // Home Injection
  initHomeInjection();
}
