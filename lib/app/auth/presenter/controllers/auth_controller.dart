import 'dart:developer';

import 'package:todo_list/app/auth/domain/usecases/get_session_user.dart';
import 'package:todo_list/app/auth/domain/usecases/log_in_google.dart';
import 'package:todo_list/app/auth/session_controller.dart';

class AuthController {
  final GetSessionUser _getSessionUser;
  final LogInGoogle _logInGoogle;
  final SessionController _sessionController;

  AuthController(
    this._getSessionUser,
    this._logInGoogle,
    this._sessionController,
  );

  Future<void> getSessionUser() async {
    final result = await _getSessionUser();

    result.fold(
      (l) {
        //Change error state to show Alert
        log(l.toString());
      },
      (r) {
        _sessionController.setLoggedUser(r);
      },
    );
  }

  Future logIn() async {
    final result = await _logInGoogle();

    await result.fold(
      (l) {
        //Change error state to show Alert
        log(l.toString());
      },
      (logged) async {
        if (logged) await getSessionUser();
      },
    );
  }
}
