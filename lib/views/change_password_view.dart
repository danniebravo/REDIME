import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoadingProfile = true;
  bool _isSubmitting = false;
  UserModel? _user;

  static const Color _primaryTeal = Color(0xFF3D8B85);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await AuthService().getProfile();
      if (!mounted) return;
      setState(() {
        _user = user;
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingProfile = false);
    }
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final hasPassword = _user?.hasPassword ?? false;
    final current = _currentController.text;
    final newPwd = _newController.text;
    final confirm = _confirmController.text;

    if (hasPassword && current.isEmpty) {
      _showError('Debes ingresar tu contraseña actual');
      return;
    }
    if (newPwd != confirm) {
      _showError('La nueva contraseña y la confirmación no coinciden');
      return;
    }
    if (newPwd.length < 6) {
      _showError('La nueva contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthService().changePassword(
        currentPassword: hasPassword ? current : null,
        newPassword: newPwd,
      );
      if (!mounted) return;
      final isGoogle = _user?.isGoogleUser ?? false;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Contraseña actualizada',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            isGoogle && !hasPassword
                ? 'Ya puedes iniciar sesión con tu correo y esta contraseña.'
                : 'Tu nueva contraseña ya está activa.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
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
      Navigator.pop(context);
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final hasPassword = _user?.hasPassword ?? false;
    final isGoogle = _user?.isGoogleUser ?? false;
    final title = hasPassword ? 'Cambiar contraseña' : 'Crear contraseña';
    final intro = hasPassword
        ? 'Ingresa tu contraseña actual y elige una nueva.'
        : (isGoogle
            ? 'Tu cuenta se creó con Google. Aquí puedes establecer una contraseña para también poder iniciar sesión con tu correo.'
            : 'Define una contraseña nueva para tu cuenta.');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primaryTeal,
        foregroundColor: Colors.white,
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      intro,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (hasPassword) ...[
                      _PasswordField(
                        controller: _currentController,
                        hint: 'Contraseña actual',
                        obscure: _obscureCurrent,
                        onToggle: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _PasswordField(
                      controller: _newController,
                      hint: 'Nueva contraseña (mín 6 caracteres)',
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 12),
                    _PasswordField(
                      controller: _confirmController,
                      hint: 'Confirmar nueva contraseña',
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _isSubmitting
                            ? 'Guardando...'
                            : (hasPassword
                                ? 'Cambiar contraseña'
                                : 'Crear contraseña'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 18,
            color: Colors.black38,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
