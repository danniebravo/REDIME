

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/profile_usecases.dart';
import 'profile_viewmodel.dart';

// ─── Inyección de dependencias ────────────────────────────────────────────────
ProfileViewModel buildProfileViewModel() {
  final dataSource = ProfileLocalDataSource();
  final repository = ProfileRepositoryImpl(dataSource);
  return ProfileViewModel(
    getProfileUseCase: GetProfileUseCase(repository),
    updateProfileUseCase: UpdateProfileUseCase(repository),
    deleteAccountUseCase: DeleteAccountUseCase(repository),
  );
}

// ─── ProfileView ──────────────────────────────────────────────────────────────
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

class _ProfileBodyState extends State<_ProfileBody> {
  bool _dispositivosExpanded = false;
  bool _infoExpanded = false;
  bool _cuentaExpanded = false;

  static const Color _primaryTeal = Color(0xFF3D8B85);
  static const Color _darkTeal = Color(0xFF2E6B66);

  final List<Map<String, String>> _dispositivos = [
    {
      'dispositivo': 'Camara sony',
      'estado': 'Parte de la exibicion:\nEl trono del espectador olvidado',
      'fecha': '05/04/2025',
    },
    {
      'dispositivo': 'Camara sony',
      'estado': 'Parte de la exibicion:\nEl Faro del Ojo Público',
      'fecha': '05/04/2025',
    },
  ];

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('¿Está seguro de esta acción?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('cerrar sesión',
                style: TextStyle(color: Colors.black87, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.black87, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminarCuenta(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('¿Está seguro de esta acción?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EliminarCuentaView()));
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Eliminar cuenta',
                style: TextStyle(color: Colors.black87, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black38),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.black87, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Column(
        children: [
          _buildHeader(vm),
          Expanded(
            child: vm.isLoading && vm.profile == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      children: [
                        _buildAccordion(
                          title: 'Dispositivos Redimidos',
                          subtitle: 'Mira tu historial de dispositivos',
                          isExpanded: _dispositivosExpanded,
                          onTap: () => setState(() =>
                              _dispositivosExpanded = !_dispositivosExpanded),
                          expandedContent: _buildDispositivosTable(),
                        ),
                        const SizedBox(height: 12),
                        _buildAccordion(
                          title: 'Tu información',
                          subtitle: 'Edita tu información basica',
                          subtitleColor: _primaryTeal,
                          isExpanded: _infoExpanded,
                          onTap: () =>
                              setState(() => _infoExpanded = !_infoExpanded),
                          expandedContent: _buildInfoContent(vm),
                        ),
                        const SizedBox(height: 12),
                        _buildAccordion(
                          title: 'Cuenta',
                          subtitle: null,
                          isExpanded: _cuentaExpanded,
                          onTap: () => setState(
                              () => _cuentaExpanded = !_cuentaExpanded),
                          expandedContent: _buildCuentaContent(context),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 12.0),
            child: OutlinedButton(
              onPressed: () => _mostrarDialogoCerrarSesion(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(color: Colors.black54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cerrar sesión',
                  style: TextStyle(color: Colors.black87, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ProfileViewModel vm) {
    final nombre = vm.profile != null
        ? '${vm.profile!.nombres}\n${vm.profile!.apellidos}'
        : 'Nombre de\nUsuario';

    return Container(
      color: _primaryTeal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20, right: 20, bottom: 24, top: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.signal_cellular_4_bar,
                          color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.wifi, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Icon(Icons.battery_full,
                          color: Colors.white, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text('REDIME',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 2)),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white70)),
                    child: const Center(
                        child: Text('?',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.teal.shade200,
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _darkTeal,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.edit,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(nombre,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.2)),
                ],
              ),
            ],
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
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: 12, color: subtitleColor)),
                      ],
                    ],
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
                  border: Border(
                      top: BorderSide(color: Color(0xFFE0E0E0)))),
              child: expandedContent,
            ),
        ],
      ),
    );
  }

  Widget _buildDispositivosTable() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text('Dispositivo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(
                  flex: 4,
                  child: Text('Estado',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
              Expanded(
                  flex: 3,
                  child: Text('Fecha',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13))),
            ],
          ),
          const Divider(),
          ..._dispositivos.map(
            (d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(d['dispositivo']!,
                          style: const TextStyle(fontSize: 13))),
                  Expanded(
                      flex: 4,
                      child: Text(d['estado']!,
                          style: const TextStyle(fontSize: 12))),
                  Expanded(
                      flex: 3,
                      child: Text(d['fecha']!,
                          style: const TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContent(ProfileViewModel vm) {
    if (vm.profile == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildCampoEditable(
              vm: vm,
              label: 'Nombres',
              controller: vm.nombresController,
              campo: 'nombres'),
          _buildCampoEditable(
              vm: vm,
              label: 'Apellidos',
              controller: vm.apellidosController,
              campo: 'apellidos'),
          _buildCampoEditable(
              vm: vm,
              label: 'N. Celular',
              controller: vm.celularController,
              campo: 'celular'),
          _buildCampoEditable(
              vm: vm,
              label: 'Correo',
              controller: vm.correoController,
              campo: 'correo'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(
                    onPressed: () async {
                      final ok = await vm.guardarPerfil();
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Información guardada'),
                              duration: Duration(seconds: 2)),
                        );
                      }
                    },
                    child: Text('Guardar',
                        style: TextStyle(
                            color: _primaryTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoEditable({
    required ProfileViewModel vm,
    required String label,
    required TextEditingController controller,
    required String campo,
  }) {
    final bool editando = vm.campoEditando == campo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
          ),
          Expanded(
            child: editando
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => vm.editarCampo(campo),
                  )
                : Text(controller.text,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
          ),
          IconButton(
            icon: Icon(Icons.edit,
                size: 16,
                color: editando ? _primaryTeal : Colors.black38),
            onPressed: () => vm.editarCampo(campo),
          ),
        ],
      ),
    );
  }

  Widget _buildCuentaContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Cambiar contraseña',
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Eliminar cuenta',
                style: TextStyle(fontSize: 14, color: Colors.black87)),
            onTap: () => _mostrarDialogoEliminarCuenta(context),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pantalla: Eliminar cuenta
// ─────────────────────────────────────────────────────────────────────────────
class EliminarCuentaView extends StatefulWidget {
  const EliminarCuentaView({super.key});

  @override
  State<EliminarCuentaView> createState() => _EliminarCuentaViewState();
}

class _EliminarCuentaViewState extends State<EliminarCuentaView> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscurePass = true;
  bool _loading = false;
  String? _error;

  static const Color _primaryTeal = Color(0xFF3D8B85);

  Future<void> _continuar() async {
    if (_emailController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty) {
      setState(() => _error = 'Por favor completa todos los campos');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _loading = false);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: const Text('Cuenta eliminada',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: const Text('Tu cuenta ha sido eliminada exitosamente.',
            textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryTeal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Aceptar',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Text('REDIME',
                  style: TextStyle(
                      color: _primaryTeal,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3)),
              const SizedBox(height: 24),
              const Text('Hasta luego :(',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 12),
              const Text(
                'Pero antes, para eliminar tu cuenta, primero ingresa tu correo y contraseña para verificar que eres tu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'correoelectronico@dominio.com',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  hintText: 'contraseña',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.black38,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!,
                    style: const TextStyle(
                        color: Colors.red, fontSize: 12)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Continuar',
                          style: TextStyle(
                              color: Colors.white, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar',
                    style: TextStyle(
                        color: Colors.black54, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}