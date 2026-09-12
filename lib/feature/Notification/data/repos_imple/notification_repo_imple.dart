import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/Notification/data/models/notification_response.dart';
import 'package:smart_pharmacy/feature/Notification/domain/repos/notification_repo.dart';

class NotificationRepoImple implements NotificationRepo {
  final ApiService apiService;

  NotificationRepoImple({required this.apiService});

  @override
  Future<Either<Failure, List<NotificationResponse>>> getUserNotifications({
    bool unreadOnly = false,
  }) async {
    try {
      final data = await apiService.get(
        endPoint: ApiConstants.notifications,
        queryParameters: {'unreadOnly': unreadOnly},
      );
      return Right(NotificationResponse.listFromJson(data as List<dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final data = await apiService.get(
        endPoint: '${ApiConstants.notifications}/unread-count',
      );
      return Right(data as int);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead({required int id}) async {
    try {
      await apiService.patch(
        endPoint: '${ApiConstants.notifications}/$id/read',
        data: const {},
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllRead() async {
    try {
      await apiService.patch(
        endPoint: '${ApiConstants.notifications}/read-all',
        data: const {},
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
  }
}
}
