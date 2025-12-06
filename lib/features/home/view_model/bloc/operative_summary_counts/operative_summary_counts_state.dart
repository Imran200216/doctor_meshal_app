part of 'operative_summary_counts_bloc.dart';

sealed class OperativeSummaryCountsState extends Equatable {
  const OperativeSummaryCountsState();
}

final class OperativeSummaryCountsInitial extends OperativeSummaryCountsState {
  @override
  List<Object> get props => [];
}

final class GetOperativeSummaryCountsLoading
    extends OperativeSummaryCountsState {
  @override
  List<Object> get props => [];
}

final class GetOperativeSummaryCountsSuccess
    extends OperativeSummaryCountsState {
  final String preOperativeCounts;
  final String postOperativeCounts;
  final String submittedCountsOperative;

  const GetOperativeSummaryCountsSuccess({
    required this.preOperativeCounts,
    required this.postOperativeCounts,
    required this.submittedCountsOperative,
  });

  @override
  List<Object> get props => [
    preOperativeCounts,
    postOperativeCounts,
    submittedCountsOperative,
  ];
}

final class GetOperativeSummaryCountsFailure
    extends OperativeSummaryCountsState {
  final String message;

  const GetOperativeSummaryCountsFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class GetOperativeSummaryCountsOfflineSuccess
    extends OperativeSummaryCountsState {
  final String preOperativeCounts;
  final String postOperativeCounts;
  final String submittedCountsOperative;

  const GetOperativeSummaryCountsOfflineSuccess({
    required this.preOperativeCounts,
    required this.postOperativeCounts,
    required this.submittedCountsOperative,
  });

  @override
  List<Object> get props => [
    preOperativeCounts,
    postOperativeCounts,
    submittedCountsOperative,
  ];
}
