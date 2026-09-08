import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
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
}
