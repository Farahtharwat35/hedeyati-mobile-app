import 'package:json_annotation/json_annotation.dart';

part 'event_status.g.dart';

@JsonSerializable()
// EventStatus Class
class EventStatus {
  final int? id;
  final String status;

  EventStatus({
    this.id,
    required this.status,
  });
}