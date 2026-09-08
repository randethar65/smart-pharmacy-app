part of 'order_detail_cubit.dart';

@immutable
sealed class OrderDetailState {}

final class OrderDetailInitial extends OrderDetailState {}

final class OrderDetailLoading extends OrderDetailState {}

final class OrderDetailSuccess extends OrderDetailState {
  final OrderResponse order;
  OrderDetailSuccess(this.order);
}

final class OrderDetailFailure extends OrderDetailState {
  final String message;
  OrderDetailFailure(this.message);
}
