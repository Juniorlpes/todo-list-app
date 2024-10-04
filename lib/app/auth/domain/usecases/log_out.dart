import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class LogOut extends Usecase<void> {
  final AuthRepository _repository;

  LogOut(this._repository);

  @override
  FutureEitherResult<void> call() async {
    return await _repository.logOut();
  }
}
