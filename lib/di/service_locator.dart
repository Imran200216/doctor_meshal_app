import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth_injection.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav_injection.dart';
import 'package:meshal_doctor_booking_app/features/change_password/change_password_injection.dart';
import 'package:meshal_doctor_booking_app/features/education/education_injection.dart';
import 'package:meshal_doctor_booking_app/features/localization/localization_injection.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative_injection.dart';

final GetIt getIt = GetIt.instance;

void setUpServiceLocators() {
  // Localization Injection
  initLocalizationInjection();

  // Auth Injection
  initAuthInjection();

  // Bottom Nav Injection
  initBottomNavInjection();

  // Peri Operative Injection
  initPeriOperativeInjection();

  // Education Injection
  initEducationInjection();

  // Change Password Injection
  initChangePasswordInjection();
}
