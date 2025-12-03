part of 'doctor_feedback_bloc.dart';

sealed class DoctorFeedbackEvent extends Equatable {
  const DoctorFeedbackEvent();
}

final class WriteDoctorFeedbackEvent extends DoctorFeedbackEvent {
  final String userId;
  final String feedBack;

  const WriteDoctorFeedbackEvent({
    required this.userId,
    required this.feedBack,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, feedBack];
}

final class GetDoctorPatientFeedbacksEvent extends DoctorFeedbackEvent {
  final String userId;

  const GetDoctorPatientFeedbacksEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
