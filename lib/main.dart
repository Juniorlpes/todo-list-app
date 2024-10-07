import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/app_widget.dart';

import 'firebase_options.dart';

//TODO: Firebase branch
//1 - Entidades novas
//2 - Auth module
//3 - todos os testes unitários
//4 - Rodar e testar

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const AppWidget());
}
