import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/cart/data/models/add_to_cart_request.dart';
import 'package:smart_pharmacy/feature/cart/data/models/cart_model.dart';

abstract class CartRepos {
  /// The only read — returns the full cart (items + server total).
  Future<Either<Failure, CartModel>> getCart();

  /// Command: success/failure only. Callers refresh via [getCart].
  Future<Either<Failure, Unit>> addToCart({
    required AddToCartRequest cartModel,
  });

  Future<Either<Failure, Unit>> removeFromCart({required int id});

  /// [quantity] is a delta the server adds to the current amount (+1 / -1),
  /// not the absolute new quantity.
  Future<Either<Failure, Unit>> updateQuantityCart({
    required int id,
    required int quantity,
  });
}
