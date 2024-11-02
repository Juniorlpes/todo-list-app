import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/core/utils/typedefs.dart';

abstract class AuthRepository {
  FutureEitherResult<User> getCurrentSessionUser();
  FutureEitherResult<void> logOut();

  FutureEitherResult<bool> logInWithGoogle();
}
