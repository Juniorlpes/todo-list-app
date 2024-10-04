import 'package:cloud_firestore/cloud_firestore.dart';

///I prefer to create a generic CollectionReference<T> to be easier to use inside datasources class
abstract class DataCollectionService<T> {
  //Sometimes is needed make queries with the raw collection
  late final CollectionReference<T> collection;

  //This collection could be used in sub collection
  DataCollectionService([CollectionReference<T>? collectionRef]) {
    if (collectionRef != null) collection = collectionRef;
  }

  Future<String> create(T value);
  Future<void> update(T value);
  Future<void> delete(String id);
  Future<List<T>> getAll();
  Future<T?> getById(String id);
}
