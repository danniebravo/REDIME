import 'package:flutter/material.dart';
import 'features/onboarding/presentation/views/welcome_view.dart';
import 'features/profile/presentation/views/delete_account_view.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const RedimeApp());
}

class RedimeApp extends StatelessWidget {
  const RedimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REDIME App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // Usamos un menú temporal para que puedas navegar a ambas y probarlas
      home: const TempNavigationMenu(),
    );
  }
}

class TempNavigationMenu extends StatelessWidget {
  const TempNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Temporal REDIME'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selecciona la pantalla a visualizar:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeView()),
                );
              },
              child: const Text(
                '🎨 Ver Pantalla de Inicio / Welcome',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountView(),
                  ),
                );
              },
              child: const Text(
                '🗑️ Ver Pantalla de Eliminar Cuenta',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
