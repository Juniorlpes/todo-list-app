class GeneralAppFailure implements Exception {
  String? message;

  GeneralAppFailure({this.message});

  @override
  String toString() {
    return message ?? super.toString();
  }
}
