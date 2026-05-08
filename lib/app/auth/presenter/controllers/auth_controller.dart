import 'dart:developer';

import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/app/auth/session_controller.dart';

class AuthController {
  final AuthRepository _repository;
  final SessionController _sessionController;

  AuthController(
    this._repository,
    this._sessionController,
  );

  Future<void> getSessionUser() async {
    final result = await _repository.getCurrentSessionUser();

    result.fold(
      (l) {},
      (r) {
        _sessionController.setLoggedUser(r);
      },
    );
  }

  Future logIn() async {
    final result = await _repository.logInWithGoogle();

    await result.fold(
      (l) {
        log(l.toString());
      },
      (logged) async {
        if (logged) await getSessionUser();
      },
    );
  }
}
