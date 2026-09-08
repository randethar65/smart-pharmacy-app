class PrescriptionResponse {
  final int id;
  final String imageUrl;
  final String status;
  final DateTime createdAt;
  final int orderId;

  PrescriptionResponse({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.orderId,
  });

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionResponse(
      id: json['id'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      orderId: json['orderId'],
    );
  }
}