part of 'doctor_dashboard_summary_counts_bloc.dart';

sealed class DoctorDashboardSummaryCountsState extends Equatable {
  const DoctorDashboardSummaryCountsState();
}

final class DoctorDashboardSummaryCountsInitial
    extends DoctorDashboardSummaryCountsState {
  @override
  List<Object> get props => [];
}

final class GetDashboardSummaryCountsLoading
    extends DoctorDashboardSummaryCountsState {
  @override
  List<Object> get props => [];
}

final class GetDashboardSummaryCountsSuccess
    extends DoctorDashboardSummaryCountsState {
  final GetDashboardCountsSummaryModel getDashboardCountsSummaryModel;

  const GetDashboardSummaryCountsSuccess({
    required this.getDashboardCountsSummaryModel,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [getDashboardCountsSummaryModel];
}

final class GetDashboardSummaryCountsFailure
    extends DoctorDashboardSummaryCountsState {
  final String message;

  const GetDashboardSummaryCountsFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
