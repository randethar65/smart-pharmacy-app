part of 'notification_cubit.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationSuccess extends NotificationState {
  NotificationSuccess(this.notifications);
  final List<NotificationResponse> notifications;
}

final class NotificationFailure extends NotificationState {
  NotificationFailure(this.message);
  final String message;
}
