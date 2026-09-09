import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';

abstract class OrderRepo {
  /// GET /api/Orders — the signed-in user's orders, newest first.
  Future<Either<Failure, List<OrderResponse>>> getUserOrders();
    Future<Either<Failure,OrderResponse>> getUserOrderDetails({required int id});
      Future<Either<Failure,bool>> cancelOrder({required int id});
}
