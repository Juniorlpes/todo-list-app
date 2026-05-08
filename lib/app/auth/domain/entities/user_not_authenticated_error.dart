import 'package:todo_list/core/app_failure.dart';

class UserNotAuthenticated extends AppFailure {
  const UserNotAuthenticated([String? message]) : super(message: message);
}
