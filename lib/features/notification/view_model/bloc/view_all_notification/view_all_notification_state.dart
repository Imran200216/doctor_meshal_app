part of 'view_all_notification_bloc.dart';

sealed class ViewAllNotificationState extends Equatable {
  const ViewAllNotificationState();
}

final class ViewAllNotificationInitial extends ViewAllNotificationState {
  @override
  List<Object> get props => [];
}

final class ViewAllNotificationLoading extends ViewAllNotificationState {
  const ViewAllNotificationLoading();

  @override
  List<Object> get props => [];
}

final class ViewAllNotificationLoaded extends ViewAllNotificationState {
  final NotificationResponse notificationResponse;

  const ViewAllNotificationLoaded({required this.notificationResponse});

  @override
  // TODO: implement props
  List<Object?> get props => [notificationResponse];
}

final class ViewAllNotificationFailure extends ViewAllNotificationState {
  final String message;

  const ViewAllNotificationFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
