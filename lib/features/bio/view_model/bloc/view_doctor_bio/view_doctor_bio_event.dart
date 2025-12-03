part of 'view_doctor_bio_bloc.dart';

sealed class ViewDoctorBioEvent extends Equatable {
  const ViewDoctorBioEvent();
}

final class GetViewDoctorBioEvent extends ViewDoctorBioEvent {
  final String userId;

  const GetViewDoctorBioEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
