import 'package:flutter/foundation.dart';
import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/app/auth/domain/usecases/log_out.dart';

class SessionController extends ValueNotifier<User?> {
  final LogOut _logOut;

  SessionController(this._logOut) : super(null);

  User get currentUser => value!;
  bool get isLogged => value != null;

  void setLoggedUser(User user) {
    value = user;
  }

  Future<void> logOut() async {
    value = null;
    await _logOut();
  }
}
