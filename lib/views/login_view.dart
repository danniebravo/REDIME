import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el ViewModel usando Provider
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('REDIME'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
            const Text(
              'Inicar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              textAlign: TextAlign.center,
              'Ingresa tu correo electronico y contraseña para iniciar tu sesión',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),

            // TextField para email
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              onChanged: vm.setEmail,
            ),

            SizedBox(height: 16),

            // TextField para password
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
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
