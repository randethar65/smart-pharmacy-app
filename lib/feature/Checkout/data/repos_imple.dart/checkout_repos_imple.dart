import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/checkout_request.dart';
import 'package:smart_pharmacy/feature/Checkout/data/models/checkout_response.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/checkout_repos.dart';

class CheckoutReposImple implements CheckoutRepos {
  final ApiService apiService;

  CheckoutReposImple(this.apiService);

  @override
  Future<Either<Failure, CheckoutResponse>> checkout(
    CheckoutRequest checkoutRequest,
  ) async {
    try {
      final data = await apiService.post(
        endPoint: ApiConstants.checkout,
        data: checkoutRequest.toJson(),
      );
      return Right(CheckoutResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckoutResponse>> payOrder(int orderId) async {
    try {
      final data = await apiService.post(
        endPoint: '${ApiConstants.checkout}/$orderId/pay',
        data: const {},
      );
      return Right(CheckoutResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckoutResponse>> confirmPayment(
    String sessionId,
  ) async {
    try {
      final data = await apiService.get(
        endPoint: '${ApiConstants.checkout}/success',
        queryParameters: {'sessionId': sessionId},
      );
      return Right(
        CheckoutResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
