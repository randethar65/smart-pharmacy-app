class CartItemModel {
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final double subtotal;
  final bool needsPrescription;

  CartItemModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.needsPrescription = false,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      productName: json['productName'] as String? ?? '',
      productImage: json['productImage'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int? ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      needsPrescription: json['needsPrescription'] as bool? ?? false,
    );
  }

  CartItemModel copyWith({int? quantity}) {
    final q = quantity ?? this.quantity;
    return CartItemModel(
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      quantity: q,
      subtotal: price * q,
      needsPrescription: needsPrescription,
    );
  }
}

/// Mirrors the backend `CartResponse` — the list of lines plus the server's
/// authoritative total. `getCart()` is the single source of cart state.
class CartModel {
  final List<CartItemModel> items;
  final double total;

  CartModel({required this.items, required this.total});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List? ?? const [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }

  bool get isEmpty => items.isEmpty;

  /// Total number of units across all lines — for the cart badge.
  int get count => items.fold(0, (sum, item) => sum + item.quantity);

  /// True if any line needs a prescription — drives the cart's Rx banner.
  bool get anyRx => items.any((item) => item.needsPrescription);

  static double _totalOf(List<CartItemModel> items) =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  /// Local copy with one line's quantity changed and the total recomputed —
  /// used for optimistic updates before the server confirms.
  CartModel updateItemQuantity(int productId, int quantity) {
    final newItems = [
      for (final item in items)
        item.productId == productId
            ? item.copyWith(quantity: quantity)
            : item,
    ];
    return CartModel(items: newItems, total: _totalOf(newItems));
  }

  /// Local copy with one line removed and the total recomputed.
  CartModel removeItem(int productId) {
    final newItems =
        items.where((item) => item.productId != productId).toList();
    return CartModel(items: newItems, total: _totalOf(newItems));
  }
}
