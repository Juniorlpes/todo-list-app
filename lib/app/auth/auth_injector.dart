import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/auth/data/datasources/auth_datasource.dart';
import 'package:todo_list/app/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/app/auth/domain/usecases/get_session_user.dart';
import 'package:todo_list/app/auth/domain/usecases/log_in_google.dart';
import 'package:todo_list/app/auth/domain/usecases/log_out.dart';
import 'package:todo_list/app/auth/presenter/controllers/auth_controller.dart';
import 'package:todo_list/app/auth/session_controller.dart';
import 'package:todo_list/core/firebase/firestore_collections/users_collection.dart';

final _getIt = GetIt.instance;

void registerExportedAuthModuleDependencies() {
  _getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      AuthDatasourceImpl(
        FirebaseAuth.instance,
        GoogleSignIn(
          clientId: kIsWeb
              //TODO: put these strings from your firebase platform
              ? 'string taken from the firebase platform (env class)'
              : Platform.isIOS
                  ? 'string taken from the firebase platform'
                  : null,
          scopes: [
            'email',
          ],
        ),
        UsersCollection(),
      ),
    ),
  );

  _getIt.registerLazySingleton<SessionController>(
    () => SessionController(LogOut(_getIt.get<AuthRepository>())),
  );
}

void unregisterExportedAuthModuleDependencies() {
  _getIt.unregister<AuthRepository>();
  _getIt.unregister<SessionController>();
}

void registerAuthModuleDependencies() {
  _getIt.registerLazySingleton<GetSessionUser>(
    () => GetSessionUser(_getIt.get<AuthRepository>()),
  );
  _getIt.registerLazySingleton<LogInGoogle>(
    () => LogInGoogle(_getIt.get<AuthRepository>()),
  );
  _getIt.registerLazySingleton<AuthController>(
    () => AuthController(
      GetSessionUser(_getIt.get<AuthRepository>()),
      LogInGoogle(_getIt.get<AuthRepository>()),
      _getIt.get<SessionController>(),
    ),
  );
}

void unregisterAuthModuleDependencies() {
  _getIt.unregister<GetSessionUser>();
  _getIt.unregister<LogInGoogle>();
  _getIt.unregister<AuthController>();
}
