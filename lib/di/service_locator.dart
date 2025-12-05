import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/bloc/core_injection.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav.dart';
import 'package:meshal_doctor_booking_app/features/change_password/change_password.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/doctor_peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/edit_personal_details.dart';
import 'package:meshal_doctor_booking_app/features/education/education.dart';
import 'package:meshal_doctor_booking_app/features/feedback/injection/feedback_injection.dart';
import 'package:meshal_doctor_booking_app/features/home/home.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';
import 'package:meshal_doctor_booking_app/features/bio/bio.dart';

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

  // Bio Injection
  initBioInjection();

  // Feedback Injection
  initFeedbackInjection();

  // Notification Injection
  initNotificationInjection();
}
