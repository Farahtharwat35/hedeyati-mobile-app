import 'package:json_annotation/json_annotation.dart';

part 'event_category.g.dart';

@JsonSerializable()
// EventCategory Class
class EventCategory {
  final int? id;
  final String name;

  EventCategory({
    this.id,
    required this.name,
  });

}