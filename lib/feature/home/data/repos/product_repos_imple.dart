import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/home/data/models/prodct_detail_model.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/product_repos.dart';

class ProductReposImpl implements ProductRepos {
  final ApiService apiService;

  ProductReposImpl({required this.apiService});

  @override
  Future<Either<Failure, ProductListResult>> getProducts({
    int page = 1,
    int limit = 10,
    int? categoryId,
    String? search,
  }) async {
    try {
     
      final response = await apiService.get(
        endPoint: ApiConstants.getAllProducts,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (categoryId != null) 'categoryId': categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final data = response as Map<String, dynamic>;
      return Right(
        ProductListResult(
          products:
              ProductModel.productsFromJson(data['data'] as List<dynamic>),
          page: data['page'] as int,
          totalPages: data['totalPage'] as int,
        ),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Product>> getProduct({required int id})async {
    try {
      final response = await apiService.get(
        endPoint: "${ApiConstants.getAllProducts}/$id",
      );
     
      return Right(
      Product.fromJson(response as Map<String, dynamic>)
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
 
}
