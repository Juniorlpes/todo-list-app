import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/auth/data/datasources/auth_datasource.dart';
import 'package:todo_list/app/auth/data/repositories/auth_repository_impl.dart';
import 'package:todo_list/app/auth/domain/repositories/auth_repository.dart';
import 'package:todo_list/app/auth/domain/usecases/log_out.dart';
import 'package:todo_list/app/auth/session_controller.dart';
import 'package:todo_list/core/firebase/firestore_collections/users_collection.dart';

final getIt = GetIt.instance;

void registerExportedAuthModuleDependencies() {
  getIt.registerLazySingleton<AuthRepository>(
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

  getIt.registerLazySingleton<SessionController>(
    () => SessionController(LogOut(getIt.get<AuthRepository>())),
  );
}

void unregisterExportedAuthModuleDependencies() {
  getIt.unregister<AuthRepository>();
  getIt.unregister<SessionController>();
}

void registerAuthModuleDependencies() {}

void unregisterAuthModuleDependencies() {}
