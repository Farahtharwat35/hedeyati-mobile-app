// Event Class
class Event {
  final int? id;
  final String name;
  final String? description;
  final int categoryID;
  final DateTime startDate;
  final DateTime? endDate;
  final int status;
  final int createdBy;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Event({
    this.id,
    required this.name,
    this.description,
    required this.categoryID,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.createdBy,
    DateTime? createdAt,
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categoryID': categoryID,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}