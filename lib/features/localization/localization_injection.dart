import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/localization/cubit/localization_cubit.dart';

final GetIt getIt = GetIt.instance;

void initLocalizationInjection() {
  // Localization Cubit
  getIt.registerLazySingleton(() => LocalizationCubit());
}
