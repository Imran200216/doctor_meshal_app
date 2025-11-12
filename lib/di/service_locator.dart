import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth_injection.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav_injection.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization_injection.dart';

final GetIt getIt = GetIt.instance;

void setUpServiceLocators() {
  // Localization Injection
  initLocalizationInjection();

  // Auth Injection
  initAuthInjection();

  // Bottom Nav Injection
  initBottomNavInjection();
}
