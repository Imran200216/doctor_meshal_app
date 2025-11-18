part of 'operative_summary_counts_bloc.dart';

sealed class OperativeSummaryCountsEvent extends Equatable {
  const OperativeSummaryCountsEvent();
}

class GetOperativeSummaryCountEvent extends OperativeSummaryCountsEvent {
  final String userId;

  const GetOperativeSummaryCountEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
