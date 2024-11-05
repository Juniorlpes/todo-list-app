class GeneralAppFailure implements Exception {
  String? message;

  int? statusCode;

  GeneralAppFailure({this.message, this.statusCode});

  @override
  String toString() {
    return message ?? super.toString();
  }
}
