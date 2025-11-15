import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';

final GetIt getIt = GetIt.instance;

void initCoreInjection() {
  // Internet Connectivity Bloc
  getIt.registerLazySingleton(() => ConnectivityBloc());
}
