part of 'education_bloc.dart';

sealed class EducationEvent extends Equatable {
  const EducationEvent();
}


final class GetEducationEvent extends EducationEvent {
  final String userId;

 const  GetEducationEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];

}