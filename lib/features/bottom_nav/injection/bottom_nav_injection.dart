import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/bottom_nav.dart';

final GetIt getIt = GetIt.instance;

void initBottomNavInjection() {
  // Localization Cubit
  getIt.registerFactory(() => BottomNavCubit());
}
