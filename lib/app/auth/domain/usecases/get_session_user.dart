import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class GetSessionUser extends Usecase<User> {
  final AuthRepository _repository;

  GetSessionUser(this._repository);

  @override
  FutureEitherResult<User> call() async {
    return await _repository.getCurrentSessionUser();
  }
}
