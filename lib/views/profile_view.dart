import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/help_button.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 46);

    path.quadraticBezierTo(
      size.width / 2,
      size.height - 4,
      size.width,
      size.height - 46,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ProfileViewState extends State<ProfileView> {
  bool _devicesExpanded = false;
  bool _infoExpanded = false;
  bool _accountExpanded = false;

  static const Color _primaryTeal = Color(0xFF3A8F7D);
  static const Color _darkTeal = Color(0xFF2E6B66);
  static const Color _backgroundColor = Color(0xFFF5F5F0);
  static const Color _softGreen = Color(0xFFE7F0EE);

  final List<Map<String, String>> _devices = [
    {
      'dispositivo': 'Cámara Sony',
      'estado': 'Parte de la exhibición:\nEl trono del espectador olvidado',
      'fecha': '05/04/2025',
    },
    {
      'dispositivo': 'Teléfono antiguo',
      'estado': 'Parte de la exhibición:\nEl Faro del Ojo Público',
      'fecha': '05/04/2025',
    },
  ];

  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  String campoEditando = '';
  bool _controllersHydrated = false;

  void _hydrateControllersIfNeeded(UserModel? user) {
    if (user == null || _controllersHydrated) return;
    nombresController.text = user.nombre;
    apellidosController.text = user.apellido;
    celularController.text = user.celular;
    correoController.text = user.email;
    _controllersHydrated = true;
  }

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    celularController.dispose();
    correoController.dispose();
    super.dispose();
  }

  void editarCampo(String field) {
    setState(() {
      campoEditando = campoEditando == field ? '' : field;
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '¿Está seguro de esta acción?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService().clearToken();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Cerrar sesión'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '¿Está seguro de esta acción?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Esta acción abrirá la verificación para eliminar la cuenta.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRoutes.deleteAccount);
            },
            child: const Text('Eliminar cuenta'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    _hydrateControllersIfNeeded(vm.user);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            _buildHeader(vm.user),
            if (vm.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LinearProgressIndicator(),
              ),
            if (vm.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'No se pudo cargar el perfil: ${vm.errorMessage ?? ''}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildAccordion(
                      title: 'Dispositivos Redimidos',
                      subtitle: 'Mira tu historial de dispositivos',
                      isExpanded: _devicesExpanded,
                      onTap: () {
                        setState(() {
                          _devicesExpanded = !_devicesExpanded;
                        });
                      },
                      expandedContent: _buildDevicesTable(),
                    ),
                    const SizedBox(height: 12),
                    _buildAccordion(
                      title: 'Tu información',
                      subtitle: 'Edita tu información básica',
                      subtitleColor: _primaryTeal,
                      isExpanded: _infoExpanded,
                      onTap: () {
                        setState(() {
                          _infoExpanded = !_infoExpanded;
                        });
                      },
                      expandedContent: _buildInfoContent(),
                    ),
                    const SizedBox(height: 12),
                    _buildAccordion(
                      title: 'Cuenta',
                      subtitle: 'Configuración y seguridad',
                      isExpanded: _accountExpanded,
                      onTap: () {
                        setState(() {
                          _accountExpanded = !_accountExpanded;
                        });
                      },
                      expandedContent: _buildAccountContent(context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(UserModel? user) {
    final headerText = (user?.nombreUsuario.isNotEmpty ?? false)
        ? user!.nombreUsuario
        : (user?.nombreCompleto.isNotEmpty ?? false)
            ? user!.nombreCompleto
            : 'Cargando...';

    return ClipPath(
      clipper: _ProfileHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: _primaryTeal,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 64),
            child: Column(
              children: [
                SizedBox(
                  height: 44,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'REDIME',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 2,
                        child: HelpButton(
                          size: 40,
                          iconSize: 20,
                          borderWidth: 2,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.chat);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                            color: _softGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 54,
                            color: _primaryTeal,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: _darkTeal,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        headerText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required String? subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget expandedContent,
    Color subtitleColor = Colors.black54,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
              ),
              child: expandedContent,
            ),
        ],
      ),
    );
  }

  Widget _buildDevicesTable() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Dispositivo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Estado',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Fecha',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),
          ..._devices.map(
            (device) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: Text(device['dispositivo']!)),
                  Expanded(flex: 4, child: Text(device['estado']!)),
                  Expanded(flex: 3, child: Text(device['fecha']!)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildEditableField(
            label: 'Nombres',
            controller: nombresController,
            field: 'nombres',
          ),
          _buildEditableField(
            label: 'Apellidos',
            controller: apellidosController,
            field: 'apellidos',
          ),
          _buildEditableField(
            label: 'Celular',
            controller: celularController,
            field: 'celular',
          ),
          _buildEditableField(
            label: 'Correo',
            controller: correoController,
            field: 'correo',
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                context.read<ProfileViewModel>().saveProfile(
                  context,
                  nombre: nombresController.text,
                  apellido: apellidosController.text,
                  celular: celularController.text,
                  email: correoController.text,
                );
                setState(() {
                  campoEditando = '';
                });
              },
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: _primaryTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required String field,
  }) {
    final bool isEditing = campoEditando == field;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  )
                : Text(controller.text),
          ),
          IconButton(
            onPressed: () => editarCampo(field),
            icon: Icon(
              Icons.edit,
              size: 16,
              color: isEditing ? _primaryTeal : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Cambiar contraseña'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad pendiente de implementar'),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Eliminar cuenta'),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }
}
