/// One row from GET /api/Notifications. [type] is the backend enum's name
/// (e.g. "OrderPaid", "PrescriptionRejected") — match on the string, same as
/// [order_response.dart]'s `orderStatus`.
class NotificationResponse {
  final int id;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String type;

  NotificationResponse({
    required this.id,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'] as int,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as String,
    );
  }

  /// GET /api/Notifications returns a bare JSON array.
  static List<NotificationResponse> listFromJson(List<dynamic> data) => data
      .map((e) => NotificationResponse.fromJson(e as Map<String, dynamic>))
      .toList();
}
