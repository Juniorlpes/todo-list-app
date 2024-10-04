import 'package:todo_list/app/auth/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<User> getCurrentSessionUser();
  Future<void> logOut();
  Future<bool> logInWithGoogle();
}
