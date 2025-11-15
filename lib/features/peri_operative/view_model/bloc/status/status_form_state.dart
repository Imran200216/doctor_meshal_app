part of 'status_form_bloc.dart';

sealed class StatusFormState extends Equatable {
  const StatusFormState();
}

final class StatusFormInitial extends StatusFormState {
  @override
  List<Object> get props => [];
}

final class StatusFormLoading extends StatusFormState {
  @override
  List<Object> get props => [];
}

final class StatusFormFailure extends StatusFormState {
  final String message;

  const StatusFormFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class StatusFormSuccess extends StatusFormState {
  final List<StatusFormModel> status;

  const StatusFormSuccess({required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}
