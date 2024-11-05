import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_rest_service/rest_service.dart';

class TodoRestApi extends RestService {
  TodoRestApi() : super('http://192.168.1.11:3333/api') {
    addInterceptor(PrintLogInterceptor());
    addInterceptor(AuthInterceptor(
      getToken: () async =>
          (await FirebaseAuth.instance.currentUser?.getIdToken(true)) ?? '',
    ));
  }
}
