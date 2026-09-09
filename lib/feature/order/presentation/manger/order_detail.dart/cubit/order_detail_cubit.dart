import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/Checkout/domain/repos/checkout_repos.dart';
import 'package:smart_pharmacy/feature/order/data/models/order_response.dart';
import 'package:smart_pharmacy/feature/order/domain/repos/order_repo.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({
    required this.orderRepo,
    required this.checkoutRepos,
  }) : super(OrderDetailInitial());

  final OrderRepo orderRepo;
   final CheckoutRepos checkoutRepos;

  Future<void> fetchDetails({required int id}) async {
    emit(OrderDetailLoading());
    final result = await orderRepo.getUserOrderDetails(id: id);
    result.fold(
      (failure) => emit(OrderDetailFailure(failure.message)),
      (order) => emit(OrderDetailSuccess(order)),
    );
  }

  Future<void> cancelOrder({required int id}) async {
    emit(OrderDetailLoading());
    final result = await orderRepo.cancelOrder(id: id);
    result.fold(
      (failure) => emit(OrderDetailFailure(failure.message)),
      // Reload — the order's status is now "Cancelled", the UI reacts to that.
      (_) => fetchDetails(id: id),
    );
  }

  /// Pay an already-created order (status "Pending").
  /// Cash finalises server-side; Visa returns a Stripe URL to open.
Future<void> payOrder(OrderResponse order) async {
  emit(OrderDetailLoading());
    final result = await checkoutRepos.payOrder(order.id);
    result.fold(
      (failure) => emit(OrderDetailFailure(failure.message)),
      (res) {
        if (!res.success) {
          emit(OrderDetailFailure(res.errorMessage ?? 'Payment failed'));
        } else if (res.checkoutUrl != null && res.checkoutUrl!.isNotEmpty) {
          emit(OrderDetailPayRedirect(
            amount: order.total,
            checkoutUrl: res.checkoutUrl!,
          ));
      } else {
          // Cash — the order is now Paid; reload so the UI reflects it.
          fetchDetails(id: order.id);
      }
    },
  );
}
}
