import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class LogInGoogle extends Usecase<bool> {
  final AuthRepository _repository;

  LogInGoogle(this._repository);

  @override
  FutureEitherResult<bool> call() async {
    return await _repository.logInWithGoogle();
  }
}
