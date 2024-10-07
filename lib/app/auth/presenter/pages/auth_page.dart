import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/app/auth/presenter/controllers/auth_controller.dart';
import 'package:todo_list/app/auth/session_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final sessionController = GetIt.I.get<SessionController>();
  final controller = GetIt.I.get<AuthController>();

  @override
  void initState() {
    super.initState();

    sessionController.addListener(_navigateToHome);
    Future.delayed(
      const Duration(milliseconds: 100),
      _verifySession,
    );
  }

  void _navigateToHome() {
    if (sessionController.isLogged) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => context.go('/home'),
      );
    }
  }

  Future<void> _verifySession() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    await controller.getSessionUser().then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Improve this page
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogIn'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: controller.logIn,
          child: const Text('Google'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    sessionController.removeListener(_navigateToHome);
    super.dispose();
  }
}
