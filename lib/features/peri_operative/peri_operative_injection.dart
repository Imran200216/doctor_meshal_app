import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/presentation/cubit/operative_selected_chip_cubit.dart';

final GetIt getIt = GetIt.instance;

void initPeriOperativeInjection() {
  // Operative Selected Chip Cubit
  getIt.registerFactory(() => OperativeSelectedChipCubit());
}
