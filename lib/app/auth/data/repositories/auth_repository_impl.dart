import 'package:todo_list/app/auth/data/datasources/auth_datasource.dart';
import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/app/auth/domain/entities/user_not_authenticated_error.dart';
import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/core/app_failure.dart';
import 'package:todo_list/core/utils/either.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  FutureEitherResult<User> getCurrentSessionUser() async {
    try {
      return right(await _datasource.getCurrentSessionUser());
    } on UserNotAuthenticated catch (e) {
      return left(e);
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<bool> logInWithGoogle() async {
    try {
      return right(await _datasource.logInWithGoogle());
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<void> logOut() async {
    try {
      return right(await _datasource.logOut());
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }
}
