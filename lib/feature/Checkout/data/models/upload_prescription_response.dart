class PrescriptionResponse {
  final int id;
  final String imageUrl;
  final String status;
  final DateTime createdAt;
  final int orderId;

  /// Pharmacist's reason — set only when [status] is "Rejected".
  final String? note;

  PrescriptionResponse({
    required this.id,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.orderId,
    this.note,
  });

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionResponse(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderId: json['orderId'] as int,
      note: json['note'] as String?,
    );
  }

  /// GET /api/Prescriptions/order/{orderId} returns a bare JSON array.
  static List<PrescriptionResponse> listFromJson(List<dynamic> data) => data
      .map((e) => PrescriptionResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}