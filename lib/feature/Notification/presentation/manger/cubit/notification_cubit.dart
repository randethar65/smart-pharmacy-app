import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/Notification/data/models/notification_response.dart';
import 'package:smart_pharmacy/feature/Notification/domain/repos/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({required this.notificationRepo})
      : super(NotificationInitial());

  final NotificationRepo notificationRepo;

  // Registered app-wide (see dependency_injection.dart) so ProfileView's
  // badge and this screen's list always read the same live number — a
  // ValueNotifier instead of NotificationState because the badge needs it
  // before the list is ever fetched, and on screens this cubit's
  // Initial/Loading/Success/Failure states don't describe.
  final unreadCount = ValueNotifier<int>(0);

  Future<void> fetchUnreadCount() async {
    final result = await notificationRepo.getUnreadCount();
    result.fold(
      (failure) {}, // best-effort — the badge just stays as it was
      (count) => unreadCount.value = count,
    );
  }

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    final result = await notificationRepo.getUserNotifications();
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (notifications) {
        unreadCount.value = notifications.where((n) => !n.isRead).length;
        emit(NotificationSuccess(notifications));
      },
    );
  }

  Future<void> markAsRead(int id) async {
    final result = await notificationRepo.markAsRead(id: id);
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      // The reply carries no body worth showing — just reload so the dot
      // for this one notification disappears.
      (_) => fetchNotifications(),
    );
  }

  Future<void> markAllRead() async {
    final result = await notificationRepo.markAllRead();
    result.fold(
      (failure) => emit(NotificationFailure(failure.message)),
      (_) => fetchNotifications(),
    );
  }

  @override
  Future<void> close() {
    unreadCount.dispose();
    return super.close();
  }
}
