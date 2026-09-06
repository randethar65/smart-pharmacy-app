import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/home/data/models/category_model.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/category_repos.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required this.categoryRepos}) : super(CategoryInitial());
    
final CategoryRepos categoryRepos;

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    final result = await categoryRepos.getCategories();
    result.fold(
      (failure) => emit(CategoryFailure(errorMessage: failure.message)),
      (categories) => emit(CategorySucess(categories: categories)),
    );
  }

}
