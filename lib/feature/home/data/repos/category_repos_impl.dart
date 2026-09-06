import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/category_repos.dart';

class CategoryReposImpl implements CategoryRepos {
  final ApiService apiService;

  CategoryReposImpl({required this.apiService});

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      // GET /api/Categories يرجّع مصفوفة JSON مباشرة، مو كائن فيه "data".
      final response = await apiService.get(
        endPoint: ApiConstants.getAllCategories,
      );
      final categoryList =
          CategoryModel.categoriesFromJson(response as List<dynamic>);
      return Right(categoryList);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
