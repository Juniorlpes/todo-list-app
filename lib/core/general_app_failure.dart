import 'rest_service/rest_status_code.dart';

class GeneralAppFailure implements Exception {
  String? message;
  RestStatusCode? statusCode;

  GeneralAppFailure({this.message, this.statusCode});

  @override
  String toString() {
    return message ?? super.toString();
  }
}
