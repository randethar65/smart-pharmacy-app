class OrderResponse {
  final int id;
  final DateTime orderDate;

  /// "Pending" | "Processing" | "Shipped" | "Delivered" | "Cancelled" |
  /// "Paid" | "AwaitingPrescription"
  final String orderStatus;

  /// "Cash" | "Visa"
  final String paymentMethod;
  final String phoneNumber;
  final String city;
  final String street;
  final List<OrderItemResponse> items;
  final double total;

  OrderResponse({
    required this.id,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentMethod,
    required this.phoneNumber,
    required this.city,
    required this.street,
    required this.items,
    required this.total,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        id: json['id'] as int,
        orderDate: DateTime.parse(json['orderDate'] as String),
        orderStatus: json['orderStatus'] as String,
        paymentMethod: json['paymentMethod'] as String,
        phoneNumber: json['phoneNumber'] as String? ?? '',
        city: json['city'] as String? ?? '',
        street: json['street'] as String? ?? '',
        items: (json['items'] as List<dynamic>? ?? const [])
            .map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num).toDouble(),
      );

  /// The endpoint returns a bare JSON array.
  static List<OrderResponse> listFromJson(List<dynamic> data) => data
      .map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}

class OrderItemResponse {
  final int productId;
  final String productName;

  /// Full image URL, e.g. https://.../Images/xxxx.png
  final String? productImage;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItemResponse({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      OrderItemResponse(
        productId: json['productId'] as int,
        productName: json['productName'] as String? ?? '',
        productImage: json['productImage'] as String?,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        subtotal: (json['subtotal'] as num).toDouble(),
      );
}
