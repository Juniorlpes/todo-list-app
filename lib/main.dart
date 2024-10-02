import 'package:flutter/material.dart';
import 'package:todo_list/app/app_widget.dart';

import 'core/scripts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  runApp(const AppWidget());
}
