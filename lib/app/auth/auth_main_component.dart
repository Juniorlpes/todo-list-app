import 'package:flutter/material.dart';
import 'package:todo_list/app/auth/presenter/pages/auth_page.dart';

import 'auth_injector.dart';

class AuthMainComponent extends StatefulWidget {
  const AuthMainComponent({super.key});

  @override
  State<AuthMainComponent> createState() => _AuthMainComponentState();
}

class _AuthMainComponentState extends State<AuthMainComponent> {
  @override
  void initState() {
    super.initState();

    registerAuthModuleDependencies();
  }

  @override
  void dispose() {
    unregisterAuthModuleDependencies();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const AuthPage();
}
