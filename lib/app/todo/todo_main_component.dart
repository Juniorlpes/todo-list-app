import 'package:flutter/material.dart';

import 'todo_injector.dart';
import 'presenter/pages/todo_page.dart';

class TodoMainComponent extends StatefulWidget {
  const TodoMainComponent({super.key});

  @override
  State<TodoMainComponent> createState() => _TodoMainComponentState();
}

class _TodoMainComponentState extends State<TodoMainComponent> {
  @override
  void initState() {
    super.initState();

    registerTodoModuleDependencies();
  }

  @override
  void dispose() {
    unregisterTodoModuleDependencies();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TodoPage();
}
