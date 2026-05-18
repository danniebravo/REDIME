import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/help_button.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/profile_usecases.dart';
import '../viewmodels/profile_viewmodel.dart';

ProfileViewModel buildProfileViewModel() {
  final dataSource = ProfileLocalDataSource();
  final repository = ProfileRepositoryImpl(dataSource);

  return ProfileViewModel(
    getProfileUseCase: GetProfileUseCase(repository),
    updateProfileUseCase: UpdateProfileUseCase(repository),
    deleteAccountUseCase: DeleteAccountUseCase(repository),
  );
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => buildProfileViewModel()..loadProfile(),
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
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

class _ProfileBodyState extends State<_ProfileBody> {
  bool _devicesExpanded = false;
  bool _infoExpanded = false;
  bool _accountExpanded = false;

  static const Color _primaryTeal = Color(0xFF3A8F7D);
  static const Color _darkTeal = Color(0xFF2F7168);
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

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          '¿Está seguro de esta acción?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
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
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Eliminar cuenta',
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Column(
          children: [
            _buildHeader(viewModel),
            Expanded(
              child: viewModel.isLoading && viewModel.profile == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
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
                            expandedContent: _buildInfoContent(viewModel),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
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

  Widget _buildHeader(ProfileViewModel viewModel) {
    final name = viewModel.profile != null
        ? '${viewModel.profile!.nombres}\n${viewModel.profile!.apellidos}'
        : 'Nombre De\nUsuario';

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
                        name,
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
    Color subtitleColor = Colors.black54,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget expandedContent,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 14.0,
              ),
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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Dispositivo',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Estado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Fecha',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const Divider(),
          ..._devices.map(
            (device) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      device['dispositivo']!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      device['estado']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      device['fecha']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContent(ProfileViewModel viewModel) {
    if (viewModel.profile == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildEditableField(
            viewModel: viewModel,
            label: 'Nombres',
            controller: viewModel.nombresController,
            field: 'nombres',
          ),
          _buildEditableField(
            viewModel: viewModel,
            label: 'Apellidos',
            controller: viewModel.apellidosController,
            field: 'apellidos',
          ),
          _buildEditableField(
            viewModel: viewModel,
            label: 'N. Celular',
            controller: viewModel.celularController,
            field: 'celular',
          ),
          _buildEditableField(
            viewModel: viewModel,
            label: 'Correo',
            controller: viewModel.correoController,
            field: 'correo',
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: viewModel.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    onPressed: () async {
                      final ok = await viewModel.guardarPerfil();

                      if (!mounted) return;

                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Información guardada'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        color: _primaryTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required ProfileViewModel viewModel,
    required String label,
    required TextEditingController controller,
    required String field,
  }) {
    final bool isEditing = viewModel.campoEditando == field;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => viewModel.editarCampo(field),
                  )
                : Text(
                    controller.text,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 16,
              color: isEditing ? _primaryTeal : Colors.black38,
            ),
            onPressed: () => viewModel.editarCampo(field),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Cambiar contraseña',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
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
            title: const Text(
              'Eliminar cuenta',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }
}
