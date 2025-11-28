import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/peri_operative.dart';

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

  // View Submitted Form Details Section Bloc
  getIt.registerFactory(
    () => ViewSubmittedFormDetailsSectionBloc(
      graphQLService: getIt<GraphQLService>(),
    ),
  );
}
