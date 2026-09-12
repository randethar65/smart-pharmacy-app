import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';

abstract class CategoryRepos {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  
}