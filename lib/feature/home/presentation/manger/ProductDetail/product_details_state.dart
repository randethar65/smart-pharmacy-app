part of 'product_details_cubit.dart';

@immutable
sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}
final class ProductDetailsLoading extends ProductDetailsState {}
final class ProductDetailsSuccess extends ProductDetailsState {
  final Product result;
  ProductDetailsSuccess({required this.result});


}
final class ProductDetailsFailure extends ProductDetailsState {

  final String errorMessage; 
  ProductDetailsFailure({required this.errorMessage});
   }
