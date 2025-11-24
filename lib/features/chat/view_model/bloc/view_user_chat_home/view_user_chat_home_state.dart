part of 'view_user_chat_home_bloc.dart';

sealed class ViewUserChatHomeState extends Equatable {
  const ViewUserChatHomeState();
}

final class ViewUserChatHomeInitial extends ViewUserChatHomeState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatHomeLoading extends ViewUserChatHomeState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatHomeSuccess extends ViewUserChatHomeState {
  final ViewUserChatHomeModel viewUserChatHomeModel;

  const GetViewUserChatHomeSuccess({required this.viewUserChatHomeModel});

  @override
  // TODO: implement props
  List<Object?> get props => [viewUserChatHomeModel];
}

final class GetViewUserChatHomeFailure extends ViewUserChatHomeState {
  final String message;

  const GetViewUserChatHomeFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
