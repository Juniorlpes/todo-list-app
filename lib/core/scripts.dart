import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../app/todo/data/models/todo_model.dart';

Future<void> initHive() async {
  if (Hive.isAdapterRegistered(1)) {
    return;
  }
  if (!kIsWeb) {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }
  Hive.registerAdapter(TodoItemModelAdapter());
}
