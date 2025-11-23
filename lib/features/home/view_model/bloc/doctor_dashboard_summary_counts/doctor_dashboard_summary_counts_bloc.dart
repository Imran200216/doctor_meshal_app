import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/home/model/get_dashboard_counts_summary_model.dart';

part 'doctor_dashboard_summary_counts_event.dart';

part 'doctor_dashboard_summary_counts_state.dart';

class DoctorDashboardSummaryCountsBloc
    extends
        Bloc<
          DoctorDashboardSummaryCountsEvent,
          DoctorDashboardSummaryCountsState
        > {
  final GraphQLService graphQLService;

  DoctorDashboardSummaryCountsBloc({required this.graphQLService})
    : super(DoctorDashboardSummaryCountsInitial()) {
    // Get Doctor Dashboard Summary Count Event
    on<GetDoctorDashboardSummaryCountsEvent>((event, emit) async {
      emit(GetDashboardSummaryCountsLoading());

      try {
        String query =
            '''
        query Get_dashboard_counts_summary {
  get_dashboard_counts_summary(user_id: "${event.userId}") {
    post_operative_submited
    pre_operative_submited
    total_education_articles
    total_patient
  }
}
''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(
            GetDashboardSummaryCountsFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        final data = result.data;

        if (data == null) {
          emit(GetDashboardSummaryCountsFailure(message: 'No data found.'));
          return;
        }

        final summaryModel = GetDashboardCountsSummaryModel.fromJson(data);

        emit(
          GetDashboardSummaryCountsSuccess(
            getDashboardCountsSummaryModel: summaryModel,
          ),
        );
      } catch (e) {
        emit(GetDashboardSummaryCountsFailure(message: e.toString()));
      }
    });
  }
}
