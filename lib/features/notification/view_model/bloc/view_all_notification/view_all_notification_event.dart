part of 'view_all_notification_bloc.dart';

sealed class ViewAllNotificationEvent extends Equatable {
  const ViewAllNotificationEvent();
}

final class GetViewAllNotificationEvent extends ViewAllNotificationEvent {
  final String userId;

  const GetViewAllNotificationEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
