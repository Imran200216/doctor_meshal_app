part of 'doctor_feedback_bloc.dart';

sealed class DoctorFeedbackState extends Equatable {
  const DoctorFeedbackState();
}

final class DoctorFeedbackInitial extends DoctorFeedbackState {
  @override
  List<Object> get props => [];
}

final class WriteDoctorFeedbackLoading extends DoctorFeedbackState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class WriteDoctorFeedbackSuccess extends DoctorFeedbackState {
  final String message;

  const WriteDoctorFeedbackSuccess({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class WriteDoctorFeedbackFailure extends DoctorFeedbackState {
  final String message;

  const WriteDoctorFeedbackFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class GetPatientFeedbacksLoading extends DoctorFeedbackState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetPatientFeedbacksSuccess extends DoctorFeedbackState {
  final List<FeedbackModel> feedbacks;

  const GetPatientFeedbacksSuccess({required this.feedbacks});

  @override
  // TODO: implement props
  List<Object?> get props => [feedbacks];
}

final class GetPatientFeedbacksFailure extends DoctorFeedbackState {
  final String message;

  const GetPatientFeedbacksFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
