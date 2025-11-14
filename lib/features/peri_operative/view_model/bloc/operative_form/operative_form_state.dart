part of 'operative_form_bloc.dart';

sealed class OperativeFormState extends Equatable {
  const OperativeFormState();
}

final class OperativeFormInitial extends OperativeFormState {
  @override
  List<Object> get props => [];
}

final class OperativeFormLoading extends OperativeFormState {
  @override
  List<Object> get props => [];
}

final class OperativeFormSuccess extends OperativeFormState {
  final List<OperativeForm> operativeForm;

  const OperativeFormSuccess({required this.operativeForm});

  @override
  List<Object> get props => [operativeForm];
}

final class OperativeFormFailure extends OperativeFormState {
  final String message;

  const OperativeFormFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
