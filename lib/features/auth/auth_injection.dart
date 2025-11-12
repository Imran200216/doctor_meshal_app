import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/auth/presentation/cubit/auth_selected_type_cubit.dart';

final GetIt getIt = GetIt.instance;

void initAuthInjection() {
  // Auth Selected Type Cubit
  getIt.registerLazySingleton(() => AuthSelectedTypeCubit());
}
