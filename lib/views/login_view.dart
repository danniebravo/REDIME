import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'package:flutter/gestures.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenemos el ViewModel usando Provider
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('REDIME'),
        automaticallyImplyLeading: false,
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
              'Iniciar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              textAlign: TextAlign.center,
              'Ingresa tu correo electronico y contraseña para iniciar tu sesión',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),

            SizedBox(height: 26),

            // TextField para email
            TextField(
              decoration: InputDecoration(
                labelText: 'correoelectrónico@dominio.com',
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
                labelText: 'Contraseña',
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
                    onPressed: () => vm.login(context),
                    child: Text('Continuar'),
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

            Text.rich(
              TextSpan(
                text: '¿No tienes cuenta aún',
                children: [
                  TextSpan(
                    text: ' Regístrate aquí',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('o'),
                ),
                Expanded(child: Divider()),
              ],
            ),

            SizedBox(height: 24),

            // Botón de google
            vm.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => vm.login(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2504/2504739.png',
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text('Continuar con Google'),
                      ],
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 232, 240, 245),
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),

            SizedBox(height: 24),

            const Text.rich(
              TextSpan(
                text: 'Al hacer clic en continuar, aceptas nuestros',
                style: TextStyle(
                  color: Color.fromARGB(255, 138, 136, 136),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: ' Terminos de servicio y Politica de privacidad',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
