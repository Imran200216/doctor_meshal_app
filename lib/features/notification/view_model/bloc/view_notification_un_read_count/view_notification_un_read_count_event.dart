part of 'view_notification_un_read_count_bloc.dart';

sealed class ViewNotificationUnReadCountEvent extends Equatable {
  const ViewNotificationUnReadCountEvent();
}

final class GetViewNotificationUnReadCountEvent
    extends ViewNotificationUnReadCountEvent {
  final String userId;

  const GetViewNotificationUnReadCountEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
