part of 'update_user_profile_details_bloc.dart';

sealed class UpdateUserProfileDetailsState extends Equatable {
  const UpdateUserProfileDetailsState();
}

final class UpdateUserProfileDetailsInitial
    extends UpdateUserProfileDetailsState {
  @override
  List<Object> get props => [];
}

final class UpdateUserProfileDetailsLoading
    extends UpdateUserProfileDetailsState {
  @override
  List<Object> get props => [];
}

final class UpdateUserProfileDetailsSuccess
    extends UpdateUserProfileDetailsState {
  final String message;

  const UpdateUserProfileDetailsSuccess({required this.message});


  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class UpdateUserProfileDetailsFailure
    extends UpdateUserProfileDetailsState {
  final String message;

  const UpdateUserProfileDetailsFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
