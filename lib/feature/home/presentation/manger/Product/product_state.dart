part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductLoading extends ProductState {}
final class ProductSuccess extends ProductState {
final ProductListResult result;

  ProductSuccess({required this.result});

}
final class ProductFailure extends ProductState {
  final String errorMessage; 
  ProductFailure({required this.errorMessage});
   }
