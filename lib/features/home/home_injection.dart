import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/operative_summary_counts/operative_summary_counts_bloc.dart';

final GetIt getIt = GetIt.instance;

void initHomeInjection() {
  // Operative Summary Counts Bloc
  getIt.registerFactory(
    () => OperativeSummaryCountsBloc(graphQLService: getIt<GraphQLService>()),
  );
}
