import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/bloc/core_injection.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_api_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_web_socket_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/auth/injection/auth_injection.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/injection/bottom_nav_injection.dart';
import 'package:meshal_doctor_booking_app/features/change_password/injection/change_password_injection.dart';
import 'package:meshal_doctor_booking_app/features/chat/injection/chat_injection.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/injection/doctor_peri_operative_injection.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/injection/edit_profile_details_injection.dart';
import 'package:meshal_doctor_booking_app/features/education/injection/education_injection.dart';
import 'package:meshal_doctor_booking_app/features/home/injection/home_injection.dart';
import 'package:meshal_doctor_booking_app/features/localization/injection/localization_injection.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/injection/peri_operative_injection.dart';

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

  // chat Graphql Web Socket Service
  getIt.registerSingletonAsync<ChatGraphQLWebSocketService>(() async {
    final service = ChatGraphQLWebSocketService();

    await service.init(websocketEndpoint: AppApiConstants.webSocketUrl);

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
