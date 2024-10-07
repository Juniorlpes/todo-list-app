import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/app/auth/auth_main_component.dart';
import 'package:todo_list/app/auth/session_controller.dart';
import 'package:todo_list/app/todo/todo_main_component.dart';

import 'app_widget.dart';

final appRoutes = GoRouter(
  navigatorKey: NavigationService.instance.navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/auth',
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthMainComponent(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const TodoMainComponent(),
      redirect: (_, __) {
        if (!GetIt.instance.get<SessionController>().isLogged) {
          return '/auth';
        }
        return null;
      },
    ),
  ],
);
