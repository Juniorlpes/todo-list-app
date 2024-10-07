import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/core/firebase/firestore_collection_service.dart';
import 'package:todo_list/shared/utils/constants.dart';

//I could have created a new collection and make a relationship between users and todos, but I prefer to create just a subcollection
class TodoSubCollection implements DataCollectionService<TodoItemModel> {
  final _colectionName = 'todo_list';

  @override
  late final CollectionReference<TodoItemModel> collection;

  TodoSubCollection(String userId, [FirebaseFirestore? firestore]) {
    collection = (firestore ?? FirebaseFirestore.instance)
        .collection(USERS_COLLECTION_NAME)
        .doc(userId)
        .collection(_colectionName)
        .withConverter(
          fromFirestore: (snap, _) =>
              TodoItemModel.fromFireDoc(snap.id, snap.data()!),
          toFirestore: (todo, _) => todo.toMap(),
        );
  }

  @override
  Future<String> create(TodoItemModel value) async {
    await collection.doc(value.id).set(value);
    return value.id;
  }

  @override
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<List<TodoItemModel>> getAll() async {
    final result = await collection.get();

    return List.generate(
      result.docs.length,
      (index) => result.docs[index].data(),
    );
  }

  @override
  Future<TodoItemModel?> getById(String id) async {
    final result = await collection.doc(id).get();

    if (!result.exists) return null;

    return result.data()!;
  }

  @override
  Future<void> update(TodoItemModel value) async {
    await collection.doc(value.id).update(value.toMap());
  }
}
