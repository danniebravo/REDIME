import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el ViewModel usando Provider
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text('Login MVVM')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextField para email
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: vm.setEmail,
            ),

            SizedBox(height: 16),

            // TextField para password
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: vm.setPassword,
            ),

            SizedBox(height: 24),

            // Botón de login o indicador de carga
            vm.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => vm.login(),
                    child: Text('Login'),
                  ),

            SizedBox(height: 24),

            // Mostrar mensaje de bienvenida si hay un usuario logueado
            if (vm.user != null)
              Text(
                'Bienvenido, ${vm.user!.name}!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}