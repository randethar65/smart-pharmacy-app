import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/order/data/Models/order_response.dart';
import 'package:smart_pharmacy/feature/order/domain/repos/order_repo.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({required this.orderRepo}) : super(OrderDetailInitial());

  final OrderRepo orderRepo;

  Future<void> fetchDetails({required int id}) async {
    emit(OrderDetailLoading());
    final result = await orderRepo.getUserOrderDetails(id: id);
    result.fold(
      (failure) => emit(OrderDetailFailure(failure.message)),
      (order) => emit(OrderDetailSuccess(order)),
    );
  }
}
