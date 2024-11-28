// EventStatus Class
class EventStatus {
  final int? id;
  final String status;

  EventStatus({
    this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
    };
  }
}