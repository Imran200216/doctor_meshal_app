part of 'status_form_bloc.dart';

sealed class StatusFormEvent extends Equatable {
  const StatusFormEvent();
}

class GetStatusFormEvent extends StatusFormEvent {
  final String userId;

  const GetStatusFormEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
