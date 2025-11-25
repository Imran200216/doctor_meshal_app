part of 'view_user_chat_home_bloc.dart';

abstract class ViewUserChatHomeState extends Equatable {
  const ViewUserChatHomeState();

  @override
  List<Object> get props => [];
}

class ViewUserChatHomeInitial extends ViewUserChatHomeState {}

class GetViewUserChatHomeLoading extends ViewUserChatHomeState {}

class GetViewUserChatHomeSuccess extends ViewUserChatHomeState {
  final ViewUserChatHomeModel viewUserChatHomeModel;
  final String? notificationCount;

  const GetViewUserChatHomeSuccess({
    required this.viewUserChatHomeModel,
    this.notificationCount,
  });

  @override
  List<Object> get props => [viewUserChatHomeModel, notificationCount ?? ''];
}

class GetViewUserChatHomeFailure extends ViewUserChatHomeState {
  final String message;

  const GetViewUserChatHomeFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class GetViewUserChatRoomLoading extends ViewUserChatHomeState {}

class GetViewUserChatRoomSuccess extends ViewUserChatHomeState {
  final String id;
  final String notificationCount;

  const GetViewUserChatRoomSuccess({
    required this.id,
    required this.notificationCount,
  });

  @override
  List<Object> get props => [id, notificationCount];
}

class GetViewUserChatRoomFailure extends ViewUserChatHomeState {
  final String message;

  const GetViewUserChatRoomFailure({required this.message});

  @override
  List<Object> get props => [message];
}