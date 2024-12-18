

String formatTimeDifference(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inDays > 1) {
    return "${difference.inDays} days ago";
  } else if (difference.inDays == 1) {
    return "1 day ago";
  } else if (difference.inHours >= 1) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes >= 1) {
    return "${difference.inMinutes} minutes ago";
  } else {
    return "Just now";
  }
}