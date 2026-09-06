import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/home/data/models/prodct_detail_model.dart' show Product;
import 'package:smart_pharmacy/feature/home/domain/repos/product_repos.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({required this.productRepos}) : super(ProductDetailsInitial());
  final ProductRepos productRepos;
  Future<void> fetchProductDetails({required int id}) async {
    emit(ProductDetailsLoading());

    final result = await productRepos.getProduct(id: id);

    result.fold(
      (failure) => emit(ProductDetailsFailure(errorMessage: failure.message)),
      (product) => emit(ProductDetailsSuccess(result: product)),
    );
  }
  
}
