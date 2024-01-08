import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';

import '../stores/todos_list_store.dart';

class TodoDialog extends StatelessWidget {
  final todosStore = GetIt.I.get<TodosListStore>();

  final int listLength;
  final TodoItem? item;

  late final bool isCreating;
  final _formKey = GlobalKey<FormFieldState>();
  final textController = TextEditingController();

  TodoDialog(
    this.listLength, {
    this.item,
    super.key,
  }) {
    isCreating = item == null;

    textController.text = item?.todo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isCreating ? 'New Todo' : 'Update Todo',
        style: const TextStyle(fontSize: 20),
      ),
      content: TextFormField(
        key: _formKey,
        controller: textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        ),
        validator: (value) {
          if (value?.trim().isEmpty ?? true) return 'required field';
          return null;
        },
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      actionsPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      actions: [
        if (!isCreating)
          TextButton(
            onPressed: () {
              todosStore.deleteTodo(item!);

              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              isCreating ? createTodo() : updateTodo();

              Navigator.of(context).pop();
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  void createTodo() {
    todosStore.createTodo(TodoItem(
      todo: textController.text,
      order: listLength,
    ));
  }

  void updateTodo() {
    item!.todo = textController.text;
    todosStore.updateTodo(item!);
  }
}
