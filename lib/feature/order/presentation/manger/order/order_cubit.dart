import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
import 'package:smart_pharmacy/feature/order/domain/repos/order_repo.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required this.orderRepo}) : super(OrderInitial());

  final OrderRepo orderRepo;

  Future<void> fetchUserOrders() async {
    emit(OrderLoading());
    final result = await orderRepo.getUserOrders();
    result.fold(
      (failure) => emit(OrderFailure(failure.message)),
      (orders) => emit(OrderSuccess(orders)),
    );
  }
}
