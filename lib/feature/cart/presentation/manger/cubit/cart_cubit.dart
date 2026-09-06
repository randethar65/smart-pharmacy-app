import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/cart/data/models/add_to_cart_request.dart';
import 'package:smart_pharmacy/feature/cart/data/models/cart_model.dart';
import 'package:smart_pharmacy/feature/cart/domain/repos/cart_repos.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.cartRepos}) : super(CartInitial());

  final CartRepos cartRepos;

  /// The cart currently on screen, whether the last write succeeded or was
  /// rolled back — so a failed action doesn't lock further actions.
 //جيبلي الكارت الحالي الموجود داخل الـ state
  CartModel? get _currentCart {
     //معناها آخر حالة صدرتيها بـ emit()
    final s = state;
    if (s is CartSuccess) return s.cart;
    if (s is CartActionFailure) return s.cart;
    return null;
  }

  /// Fetches the real cart from the server. Only shows the full-screen
  /// spinner on the first load; later refreshes swap the data in place.
  Future<void> fetchCart() async {
    if (_currentCart == null) emit(CartLoading());

    final result = await cartRepos.getCart();
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (cart) => emit(CartSuccess(cart)),
    );
  }

  Future<void> addToCart(AddToCartRequest request) async {
    final result = await cartRepos.addToCart(cartModel: request);
    await result.fold(
      (failure) async => emit(CartFailure(failure.message)),
      (_) async => fetchCart(),
    );
  }
 //Optimistic Update
  Future<void> removeFromCart({required int id}) async {
    final previous = _currentCart;
    if (previous == null) return;

    // Optimistic: drop the line immediately, then confirm with the server.
    //بحذف اول اشي من شاشه المستخدم بعدين بروح بحذف من السيرفر 

    emit(CartSuccess(previous.removeItem(id)));

    final result = await cartRepos.removeFromCart(id: id);
    result.fold(
      (failure) =>
          emit(CartActionFailure(cart: previous, message: failure.message)),
      (_) => fetchCart(), // reconcile — silent, state is already CartSuccess
    );
  }

  Future<void> updateQuantityCart({required int id, required int qty}) async {
   
    final previous = _currentCart;
    if (previous == null) return;
  //بحدث اول اشي من شاشه المستخدم بعدين بروح بحذف من السيرفر 
    emit(CartSuccess(previous.updateItemQuantity(id, qty)));

    final result = await cartRepos.updateQuantityCart(id: id, quantity: qty);
    result.fold(
      (failure) =>
          emit(CartActionFailure(cart: previous, message: failure.message)),
      (_) => fetchCart(),
    );
  }
}
