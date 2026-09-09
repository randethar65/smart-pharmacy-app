import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';
import 'package:smart_pharmacy/feature/order/domain/repos/order_repo.dart';

class OrderRepoImple implements OrderRepo {
  final ApiService apiService;

  OrderRepoImple({required this.apiService});

  @override
  Future<Either<Failure, List<OrderResponse>>> getUserOrders() async {
    try {
      // GET /api/Orders returns a bare JSON array of orders.
      final response = await apiService.get(endPoint: ApiConstants.userOrders);
      return Right(OrderResponse.listFromJson(response as List<dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, OrderResponse>> getUserOrderDetails({required int id}) async {
    try {
      // GET /api/Orders/{id} returns a single order object.
      final response =
          await apiService.get(endPoint: "${ApiConstants.userOrders}/$id");
      return Right(OrderResponse.fromJson(response as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> cancelOrder({required int id}) async {
    try {
      // POST /api/Orders/{id}/cancel — no body, response ignored.
      await apiService.dio.post(
        '${ApiConstants.apiBaseUrl}${ApiConstants.cancelOrder}/$id/cancel',
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
