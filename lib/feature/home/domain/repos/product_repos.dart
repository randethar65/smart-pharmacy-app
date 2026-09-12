import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/home/data/models/prodct_detail_model.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';

abstract class ProductRepos {
  Future<Either<Failure, ProductListResult>> getProducts({
    int page = 1,
    int limit = 10,
    int? categoryId,
    String? search,
  });
 Future<Either<Failure, Product>> getProduct({required int id});
 
}


