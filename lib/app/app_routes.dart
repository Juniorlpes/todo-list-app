import 'package:go_router/go_router.dart';
import 'package:todo_list/app/todo/todo_main_component.dart';

import 'app_widget.dart';

final appRoutes = GoRouter(
  navigatorKey: NavigationService.instance.navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoMainComponent(),
    ),
  ],
);
