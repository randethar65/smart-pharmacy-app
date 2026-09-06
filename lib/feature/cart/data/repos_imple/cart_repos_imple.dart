import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/cart/data/models/add_to_cart_request.dart';
import 'package:smart_pharmacy/feature/cart/data/models/cart_model.dart';
import 'package:smart_pharmacy/feature/cart/domain/repos/cart_repos.dart';

class CartReposImple implements CartRepos {
  final ApiService apiService;

  CartReposImple({required this.apiService});

  @override
  Future<Either<Failure, CartModel>> getCart() async {
    try {
      final response = await apiService.get(endPoint: ApiConstants.getCart);
      return Right(CartModel.fromJson(response as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addToCart({
    required AddToCartRequest cartModel,
  }) async {
    try {
      await apiService.post(
        endPoint: ApiConstants.addToCart,
        data: cartModel.toJson(),
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> removeFromCart({required int id}) async {
   try {
      // DELETE /api/Cart/{productId}
      await apiService.delete(
        endPoint: "${ApiConstants.removeFromCart}/$id",
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  
  @override
  Future<Either<Failure, Unit>> updateQuantityCart({
    required int id,
    required int quantity,
  }) async {
    try {
      // PATCH /api/Cart/{productId}  body: { "quantity": <delta> }
      await apiService.patch(
        endPoint: "${ApiConstants.updateQuantityCart}/$id",
        data: {'quantity': quantity},
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
