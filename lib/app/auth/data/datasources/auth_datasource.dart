import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/auth/data/models/user_model.dart';
import 'package:todo_list/app/auth/domain/entities/user.dart';
import 'package:todo_list/app/auth/domain/entities/user_not_authenticated_error.dart';
import 'package:todo_list/core/firebase/firestore_collection_service.dart';
import 'package:todo_list/core/general_app_failure.dart';

abstract class AuthDatasource {
  Future<User> getCurrentSessionUser();
  Future<void> logOut();
  Future<bool> logInWithGoogle();
}

class AuthDatasourceImpl implements AuthDatasource {
  final fire_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final DataCollectionService<UserModel> _usersCollection;

  AuthDatasourceImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._usersCollection,
  );

  @override
  Future<User> getCurrentSessionUser() async {
    final fireUser = _firebaseAuth.currentUser;

    if (fireUser == null) {
      throw UserNotAuthenticated();
    }

    final user = await _usersCollection.getById(fireUser.uid);

    if (user != null) return user;

    await _usersCollection.create(UserModel(
      id: fireUser.uid,
      email: fireUser.email!,
      name: fireUser.displayName ?? '',
    ));

    return (await _usersCollection.getById(fireUser.uid))!;
  }

  @override
  Future<bool> logInWithGoogle() async {
    late fire_auth.UserCredential userCredential;
    if (kIsWeb) {
      userCredential = await _firebaseAuth.signInWithPopup(
        fire_auth.GoogleAuthProvider(),
      );
    } else {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw GeneralAppFailure(message: 'googleUser null');
      }

      final googleAuth = await googleUser.authentication;
      final credential = fire_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      userCredential = await _firebaseAuth.signInWithCredential(credential);
    }

    return userCredential.user != null;
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
