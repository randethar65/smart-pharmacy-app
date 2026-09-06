part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class CategoryLoading extends CategoryState {}
final class CategorySucess extends CategoryState {
  final List<CategoryModel> categories;

  CategorySucess({required this.categories});
}
final class CategoryFailure extends CategoryState {
  final String errorMessage; 
  CategoryFailure({required this.errorMessage});
   }

