import 'typedefs.dart';

abstract class UsecaseWithParams<DataReturn, Params> {
  FutureEitherResult<DataReturn> call(Params params);
}

abstract class Usecase<DataReturn> {
  FutureEitherResult<DataReturn> call();
}
