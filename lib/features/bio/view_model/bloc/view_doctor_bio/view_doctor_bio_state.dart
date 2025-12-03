part of 'view_doctor_bio_bloc.dart';

sealed class ViewDoctorBioState extends Equatable {
  const ViewDoctorBioState();
}

final class ViewDoctorBioInitial extends ViewDoctorBioState {
  @override
  List<Object> get props => [];
}

final class ViewDoctorBioLoading extends ViewDoctorBioState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class ViewDoctorBioLoaded extends ViewDoctorBioState {
  final DoctorBioDescriptionModel doctorBioDescriptionModel;

  const ViewDoctorBioLoaded({required this.doctorBioDescriptionModel});

  @override
  // TODO: implement props
  List<Object?> get props => [doctorBioDescriptionModel];
}

final class ViewDoctorBioFailure extends ViewDoctorBioState {
  final String message;

  const ViewDoctorBioFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
