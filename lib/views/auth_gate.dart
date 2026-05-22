import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_view.dart';
import 'welcome_view.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? _hasSession;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await AuthService().getToken();
    if (!mounted) return;
    setState(() => _hasSession = token != null && token.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSession == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _hasSession! ? const HomeView() : const WelcomeView();
  }
}
