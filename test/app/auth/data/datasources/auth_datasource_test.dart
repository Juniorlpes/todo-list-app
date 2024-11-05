import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_rest_service/rest_service.dart';
import 'package:todo_list/app/auth/data/datasources/auth_datasource.dart';
import 'package:todo_list/app/auth/data/models/user_model.dart';
import 'package:todo_list/core/rest_service/todo_rest_api.dart';

class MockFireAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFireUser extends Mock implements User {}

class MockRestService extends Mock implements TodoRestApi {}

void main() {
  final fireAuth = MockFireAuth();
  final googleSignIn = MockGoogleSignIn();
  final userApi = MockRestService();

  final authDatasource = AuthDatasourceImpl(
    fireAuth,
    googleSignIn,
    userApi,
  );

  setUpAll(() {
    registerFallbackValue(MockAuthCredential());
  });

  test('getSessionUser', () async {
    final user = MockFireUser();

    when(() => fireAuth.currentUser).thenAnswer((_) => user);
    when(() => user.uid).thenAnswer((_) => '123');
    when(() => user.email).thenAnswer((_) => 'test@test.com');
    when(() => user.displayName).thenAnswer((_) => 'name');
    when(() => userApi.postModel<UserModel>(any(), any(), any()))
        .thenAnswer((_) async => RestResponse<UserModel>(RestStatusCode.created)
          ..data = UserModel(
            id: '123',
            email: 'email@email.com',
            name: 'name',
          ));

    final result = await authDatasource.getCurrentSessionUser();

    expect(result.id, user.uid);
  });

  test('google signIn', () async {
    final googleAccount = MockGoogleAccount();
    final googleAuthenticator = MockGoogleAuthentication();
    final userCredential = MockUserCredential();
    final user = MockFireUser();

    when(() => googleSignIn.signIn()).thenAnswer((_) async => googleAccount);
    when(() => googleAccount.authentication).thenAnswer(
      (_) async => googleAuthenticator,
    );
    when(() => googleAuthenticator.accessToken).thenAnswer((_) => '');
    when(() => fireAuth.signInWithCredential(any()))
        .thenAnswer((_) async => userCredential);
    when(() => userCredential.user).thenAnswer((_) => user);

    final result = await authDatasource.logInWithGoogle();

    expect(result, true);
  });

  test('logOut', () async {
    when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
    when(() => fireAuth.signOut()).thenAnswer((_) async {});

    await authDatasource.logOut();
  });
}
