import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/operative_form/operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/cubit/operative_selected_chip_cubit.dart';

final GetIt getIt = GetIt.instance;

void initPeriOperativeInjection() {
  // Operative Selected Chip Cubit
  getIt.registerFactory(() => OperativeSelectedChipCubit());

  // Operative Form Bloc
  getIt.registerFactory(
    () => OperativeFormBloc(graphQLService: getIt<GraphQLService>()),
  );
}
