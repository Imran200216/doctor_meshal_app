part of 'view_notification_un_read_count_bloc.dart';

sealed class ViewNotificationUnReadCountState extends Equatable {
  const ViewNotificationUnReadCountState();
}

final class ViewNotificationUnReadCountInitial
    extends ViewNotificationUnReadCountState {
  @override
  List<Object> get props => [];
}

final class ViewNotificationUnReadCountLoading
    extends ViewNotificationUnReadCountState {
  @override
  List<Object> get props => [];
}

final class ViewNotificationUnReadCountLoaded
    extends ViewNotificationUnReadCountState {
  final int unreadNotificationCount;

  const ViewNotificationUnReadCountLoaded({
    required this.unreadNotificationCount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [unreadNotificationCount];
}

final class ViewNotificationUnReadCountFailure
    extends ViewNotificationUnReadCountState {
  final String message;

  const ViewNotificationUnReadCountFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
