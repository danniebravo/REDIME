import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

void main() {
  runApp(const RedimeApp());
}

class RedimeApp extends StatelessWidget {
  const RedimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REDIME',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8BB5B2)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.pickupStep1,
      routes: AppRoutes.routes,
    );
  }
}
