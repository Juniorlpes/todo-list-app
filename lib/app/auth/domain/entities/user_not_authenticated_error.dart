import 'package:todo_list/core/general_app_failure.dart';

class UserNotAuthenticated extends GeneralAppFailure {
  UserNotAuthenticated([String? message]) : super(message: message);
}
