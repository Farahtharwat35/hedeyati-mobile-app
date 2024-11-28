// EventCategory Class
class EventCategory {
  final int? id;
  final String name;

  EventCategory({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}