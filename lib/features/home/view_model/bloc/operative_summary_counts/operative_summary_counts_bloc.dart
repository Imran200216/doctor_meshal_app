import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'operative_summary_counts_event.dart';

part 'operative_summary_counts_state.dart';

class OperativeSummaryCountsBloc
    extends Bloc<OperativeSummaryCountsEvent, OperativeSummaryCountsState> {
  final GraphQLService graphQLService;

  OperativeSummaryCountsBloc({required this.graphQLService})
    : super(OperativeSummaryCountsInitial()) {
    // Get Operative Summary Count Event
    on<GetOperativeSummaryCountEvent>((event, emit) async {
      emit(GetOperativeSummaryCountsLoading());

      try {
        String query =
            ''' 
        
        query Get_operative_summary_counts_ {
  get_operative_summary_counts_(user_id: "${event.userId}") {
    post_operative_counts
    pre_operative_counts
    submited_counts_operative
  }
}

        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        final list = result.data?["get_operative_summary_counts_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $list");

        if (list == null) {
          AppLoggerHelper.logError(
            "No data returned for userId: ${event.userId}",
          );
          emit(
            GetOperativeSummaryCountsFailure(
              message: "No response from server",
            ),
          );
          return;
        }

        emit(
          GetOperativeSummaryCountsSuccess(
            preOperativeCounts: list["post_operative_counts"],
            postOperativeCounts: list["pre_operative_counts"],
            submittedCountsOperative: list["submited_counts_operative"],
          ),
        );
      } catch (e) {
        emit(GetOperativeSummaryCountsFailure(message: e.toString()));
      }
    });
  }
}
