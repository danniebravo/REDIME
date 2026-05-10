import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/RegisterUser_viewmodel.dart';
import 'package:flutter/gestures.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterUserViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('REDIME'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              'Crear cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const Text(
              'Crea una cuenta para ingresar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),

            const SizedBox(height: 20),

            // EMAIL
            TextField(
              decoration: InputDecoration(
                labelText: 'correoelectrónico@dominio.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              onChanged: vm.setEmail,
            ),

            const SizedBox(height: 13),

            // NOMBRE
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombres',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              onChanged: vm.setNombre,
            ),

            const SizedBox(height: 13),

            // APELLIDO
            TextField(
              decoration: InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              onChanged: vm.setApellido,
            ),

            const SizedBox(height: 13),

            // CÉDULA
            TextField(
              decoration: InputDecoration(
                labelText: 'Cédula',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              keyboardType: TextInputType.number,
              onChanged: vm.setCedula,
            ),

            const SizedBox(height: 13),

            // CELULAR
            TextField(
              decoration: InputDecoration(
                labelText: 'Número de celular',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              keyboardType: TextInputType.phone,
              onChanged: vm.setCelular,
            ),

            const SizedBox(height: 13),

            // PASSWORD
            TextField(
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),

              obscureText: true,
              onChanged: vm.setPassword,
            ),

            const SizedBox(height: 24),

            // BOTÓN REGISTER
            vm.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => vm.register(context),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),

                    child: const Text('Continuar'),
                  ),

            const SizedBox(height: 24),

            // LOGIN LINK
            Text.rich(
              TextSpan(
                text: '¿Ya tienes una cuenta?',

                children: [
                  TextSpan(
                    text: ' Inicia sesión aquí',

                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),

                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: const [
                Expanded(child: Divider(color: Colors.grey)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('o'),
                ),

                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // GOOGLE BUTTON
            ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 232, 240, 245),

                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 45),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/2504/2504739.png',
                    height: 20,
                  ),

                  const SizedBox(width: 8),

                  const Text('Continuar con Google'),
                ],
              ),
            ),

            const SizedBox(height: 24),

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
                    text: ' Términos de servicio y Política de privacidad',

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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
