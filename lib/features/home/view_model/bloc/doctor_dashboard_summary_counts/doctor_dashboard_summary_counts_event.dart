part of 'doctor_dashboard_summary_counts_bloc.dart';

sealed class DoctorDashboardSummaryCountsEvent extends Equatable {
  const DoctorDashboardSummaryCountsEvent();
}

final class GetDoctorDashboardSummaryCountsEvent
    extends DoctorDashboardSummaryCountsEvent {
  final String userId;

  const GetDoctorDashboardSummaryCountsEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
