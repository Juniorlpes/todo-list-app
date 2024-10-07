import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/app/auth/auth_injector.dart';

import 'app_routes.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();

    registerExportedAuthModuleDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp.router(
      routerConfig: appRoutes,
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }

  @override
  void dispose() {
    unregisterExportedAuthModuleDependencies();
    super.dispose();
  }
}

class NavigationService {
  NavigationService._();

  static NavigationService instance = NavigationService._();

  final navigatorKey = GlobalKey<NavigatorState>();
  BuildContext get currentContext => navigatorKey.currentContext!;
}
