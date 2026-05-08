import 'package:flutter/foundation.dart';
import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';

class SessionController extends ValueNotifier<User?> {
  final AuthRepository _repository;

  SessionController(this._repository) : super(null);

  User get currentUser => value!;
  bool get isLogged => value != null;

  void setLoggedUser(User user) {
    value = user;
  }

  Future<void> logOut() async {
    value = null;
    await _repository.logOut();
  }
}
