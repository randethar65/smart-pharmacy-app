import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/home/data/models/product_model.dart';
import 'package:smart_pharmacy/feature/home/domain/repos/product_repos.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({required this.productRepos}) : super(ProductInitial());

   final ProductRepos productRepos;

  Future<void> fetchProducts({int? categoryId, String? search}) async {
    emit(ProductLoading());

    final result = await productRepos.getProducts(
      categoryId: categoryId,
      search: search,
    );

    result.fold(
      (failure) => emit(ProductFailure(errorMessage: failure.message)),
      (products) => emit(ProductSuccess(result: products)),
    );    
}
}
