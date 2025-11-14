import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/bottom_nav/view_model/cubit/bottom_nav_cubit.dart';

final GetIt getIt = GetIt.instance;

void initBottomNavInjection() {
  // Localization Cubit
  getIt.registerFactory(() => BottomNavCubit());
}
