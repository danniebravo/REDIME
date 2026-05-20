import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';
import '../services/auth_service.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color _primaryTeal = Color(0xFF3D8B85);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final email = _emailController.text.trim();

    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes completar todos los campos')),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    final auth = AuthService();

    try {
      await auth.deleteAccount(email, password);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    await auth.clearToken();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        title: const Text(
          'Cuenta eliminada',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        content: const Text(
          'Tu cuenta ha sido eliminada exitosamente.',
          textAlign: TextAlign.center,
        ),

        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryTeal,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,

        title: const Text('Eliminar cuenta'),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 48),

              const Text(
                'REDIME',

                style: TextStyle(
                  color: _primaryTeal,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Hasta luego :(',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Antes de eliminar tu cuenta, ingresa tu correo y contraseña para verificar que eres tú.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _emailController,

                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(
                  hintText: 'correoelectronico@dominio.com',

                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black38,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),

                  isDense: true,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _passwordController,

                obscureText: _obscurePassword,

                decoration: InputDecoration(
                  hintText: 'contraseña',

                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black38,
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),

                  isDense: true,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,

                      size: 18,
                      color: Colors.black38,
                    ),

                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : _deleteAccount,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryTeal,

                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  child: const Text(
                    'Continuar',

                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(
                  'Cancelar',

                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
