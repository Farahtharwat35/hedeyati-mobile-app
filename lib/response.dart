class Response {
  final bool success;
  final String message;
  final dynamic data;

  Response({required this.success, required this.message, this.data});
}

class BadRequest extends Response {
  BadRequest(String message) : super(success: false, message: message);
}