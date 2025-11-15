import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/operative_form/operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/status/status_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/bloc/survey_operative_form/survey_operative_form_bloc.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/cubit/operation_selected_chip/operative_selected_chip_cubit.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/view_model/cubit/survey_form/survey_form_selection_cubit.dart';

final GetIt getIt = GetIt.instance;

void initPeriOperativeInjection() {
  // Operative Selected Chip Cubit
  getIt.registerFactory(() => OperativeSelectedChipCubit());

  // Operative Form Bloc
  getIt.registerFactory(
    () => OperativeFormBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Survey Form Selection Cubit
  getIt.registerFactory(() => SurveyFormSelectionCubit());

  // Survey Operative Form Bloc
  getIt.registerFactory(
    () => SurveyOperativeFormBloc(graphQLService: getIt<GraphQLService>()),
  );

  // Status Form Bloc
  getIt.registerFactory(
    () => StatusFormBloc(graphQLService: getIt<GraphQLService>()),
  );
}
