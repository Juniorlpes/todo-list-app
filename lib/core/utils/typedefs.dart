import '../../core/general_app_failure.dart';
import 'either.dart';

typedef EitherResult<T> = Either<GeneralAppFailure, T>;
typedef FutureEitherResult<T> = Future<EitherResult<T>>;
