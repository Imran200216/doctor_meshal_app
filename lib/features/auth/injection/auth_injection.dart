import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

final GetIt getIt = GetIt.instance;

void initAuthInjection() {
  // Auth Selected Type Cubit
  getIt.registerLazySingleton(() => AuthSelectedTypeCubit());

  // Email Auth Bloc
  getIt.registerFactory(() => EmailAuthBloc(getIt<GraphQLService>()));

  // User Auth Bloc
  getIt.registerFactory(() => UserAuthBloc(getIt<GraphQLService>()));
}
