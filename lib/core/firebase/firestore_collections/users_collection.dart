import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/auth/data/models/user_model.dart';
import 'package:todo_list/core/firebase/firestore_collection_service.dart';
import 'package:todo_list/core/app_failure.dart';
import 'package:todo_list/shared/utils/constants.dart';

class UsersCollection implements DataCollectionService<UserModel> {
  final _colectionName = USERS_COLLECTION_NAME;
  late final FirebaseAuth _fireAuth;

  @override
  late final CollectionReference<UserModel> collection;

  UsersCollection([FirebaseAuth? fireAuth, FirebaseFirestore? firestore]) {
    _fireAuth = fireAuth ?? FirebaseAuth.instance;
    collection = (firestore ?? FirebaseFirestore.instance)
        .collection(_colectionName)
        .withConverter(
          fromFirestore: (snap, _) =>
              UserModel.fromFireDoc(snap.id, snap.data()!),
          toFirestore: (user, _) => user.toMap(),
        );
  }

  @override
  Future<String> create(UserModel value) async {
    final authId = _fireAuth.currentUser!.uid;
    await collection.doc(authId).set(value);
    return authId;
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<List<UserModel>> getAll() {
    throw const UnexpectedFailure(message: 'Unsupported to this collection');
  }

  @override
  Future<UserModel?> getById(String id) async {
    final result = await collection.doc(id).get();

    if (!result.exists) return null;

    return result.data()!;
  }

  @override
  Future<void> update(UserModel value) async {
    await collection.doc(value.id).update(value.toMap());
  }
}
