part of 'view_doctor_operative_form_bloc.dart';

sealed class ViewDoctorOperativeFormEvent extends Equatable {
  const ViewDoctorOperativeFormEvent();
}

final class GetViewDoctorOperativeFormEvent
    extends ViewDoctorOperativeFormEvent {
  final String doctorId;
  final String formType;

  const GetViewDoctorOperativeFormEvent({
    required this.doctorId,
    required this.formType,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [doctorId, formType];
}

final class SearchDoctorOperativeFormEvent
    extends ViewDoctorOperativeFormEvent {
  final String doctorId;
  final String formType;
  final String search;

  const SearchDoctorOperativeFormEvent({required this.search, required this.doctorId, required this.formType});

  @override
  // TODO: implement props
  List<Object?> get props => [search, doctorId, formType];

}