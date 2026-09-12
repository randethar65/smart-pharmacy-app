import 'package:dartz/dartz.dart';

import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/Notification/data/models/notification_response.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationResponse>>> getUserNotifications({
    bool unreadOnly = false,
  });

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, bool>> markAsRead({required int id});

  Future<Either<Failure, bool>> markAllRead();
}
