import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/app/todo/presenter/stores/todos_list_store.dart';
import 'package:todo_list/app/todo/presenter/widgets/todo_dialog.dart';

class TodoPage extends StatelessWidget {
  final todosStore = GetIt.I.get<TodosListStore>();

  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: ValueListenableBuilder<TodoListState>(
        valueListenable: todosStore,
        builder: (_, value, __) {
          if (value is LoadingTodosState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (value is FailureTodosState) {
            return RefreshIndicator(
              onRefresh: todosStore.getAllTodoItens,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: screenSize.height * 0.4),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Error', // failure message?
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          } else {
            value as SuccessTodosFailure;

            // RefreshIndicator(
            //   onRefresh: todosStore.getAllTodoItens,

            return ReorderableListView.builder(
              itemCount: value.todosItens.length,
              onReorder: todosStore.reorder,
              itemBuilder: (_, idx) => ListTile(
                key: Key(value.todosItens[idx].id),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => TodoDialog(value.todosItens.length,
                        item: value.todosItens[idx]),
                  );
                },
                title: Text(
                  value.todosItens[idx].todo,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Checkbox.adaptive(
                  value: value.todosItens[idx].done,
                  tristate: false,
                  onChanged: (b) {
                    value.todosItens[idx].done = b!;

                    todosStore.updateTodo(value.todosItens[idx]);
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: ValueListenableBuilder<TodoListState>(
        valueListenable: todosStore,
        builder: (_, value, __) => Visibility(
          visible: value is SuccessTodosFailure,
          child: FloatingActionButton(
            onPressed: () {
              value as SuccessTodosFailure;

              showDialog(
                context: context,
                builder: (ctx) => TodoDialog(value.todosItens.length),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
