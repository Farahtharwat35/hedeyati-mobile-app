class Event {
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String image;

  Event({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'location': location,
      'image': image,
    };
  }
}