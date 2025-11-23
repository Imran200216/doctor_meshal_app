part of 'view_doctor_operative_form_bloc.dart';

sealed class ViewDoctorOperativeFormState extends Equatable {
  const ViewDoctorOperativeFormState();
}

final class ViewDoctorOperativeFormInitial
    extends ViewDoctorOperativeFormState {
  @override
  List<Object> get props => [];
}

final class GetViewDoctorOperativeFormLoading
    extends ViewDoctorOperativeFormState {
  @override
  List<Object> get props => [];
}

final class GetViewDoctorOperativeFormSuccess
    extends ViewDoctorOperativeFormState {
  final DoctorPeriOperativeFormModel forms;

  const GetViewDoctorOperativeFormSuccess({required this.forms});

  @override
  // TODO: implement props
  List<Object?> get props => [forms];
}

final class GetViewDoctorOperativeFormFailure
    extends ViewDoctorOperativeFormState {
  final String message;

  const GetViewDoctorOperativeFormFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class SearchDoctorOperativeFormLoading
    extends ViewDoctorOperativeFormState {
  @override
  List<Object> get props => [];
}

final class SearchDoctorOperativeFormSuccess
    extends ViewDoctorOperativeFormState {
  final DoctorPeriOperativeFormModel forms;

  const SearchDoctorOperativeFormSuccess({required this.forms});

  @override
  // TODO: implement props
  List<Object?> get props => [forms];
}

final class SearchDoctorOperativeFormFailure
    extends ViewDoctorOperativeFormState {
  final String message;

  const SearchDoctorOperativeFormFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
