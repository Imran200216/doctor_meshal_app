part of 'operative_form_bloc.dart';

sealed class OperativeFormEvent extends Equatable {
  const OperativeFormEvent();
}

class GetOperativeFormEvents extends OperativeFormEvent {
  final String userId;
  final String formType;

  const GetOperativeFormEvents({required this.userId, required this.formType});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, formType];
}
