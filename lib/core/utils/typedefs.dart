import '../../core/app_failure.dart';
import 'either.dart';

typedef EitherResult<T> = Either<AppFailure, T>;
typedef FutureEitherResult<T> = Future<EitherResult<T>>;
