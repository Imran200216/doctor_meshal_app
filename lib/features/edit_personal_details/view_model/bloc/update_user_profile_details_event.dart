part of 'update_user_profile_details_bloc.dart';

sealed class UpdateUserProfileDetailsEvent extends Equatable {
  const UpdateUserProfileDetailsEvent();
}

class UpdateUserProfileDetailsFormEvent extends UpdateUserProfileDetailsEvent {
  final UpdateUserProfileDetailsModel model;

  const UpdateUserProfileDetailsFormEvent({required this.model});

  @override
  // TODO: implement props
  List<Object?> get props => [model];
}
