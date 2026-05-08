abstract class AppFailure implements Exception {
  final String? message;

  const AppFailure({this.message});

  @override
  String toString() => message ?? runtimeType.toString();
}

class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.message});
}
