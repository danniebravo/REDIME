import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _dispositivosExpanded = false;
  bool _infoExpanded = false;
  bool _cuentaExpanded = false;

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

  static const Color _primaryTeal = Color(0xFF3D8B85);
  static const Color _darkTeal = Color(0xFF2E6B66);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _buildAccordion(
                  title: 'Dispositivos Redimidos',
                  subtitle: 'Mira tu historial de dispositivos',
                  isExpanded: _dispositivosExpanded,
                  onTap: () => setState(
                      () => _dispositivosExpanded = !_dispositivosExpanded),
                  expandedContent: _buildDispositivosTable(),
                ),
                const SizedBox(height: 12),
                _buildAccordion(
                  title: 'Tu información',
                  subtitle: 'Edita tu información basica',
                  subtitleColor: _primaryTeal,
                  isExpanded: _infoExpanded,
                  onTap: () => setState(() => _infoExpanded = !_infoExpanded),
                  expandedContent: _buildInfoContent(),
                ),
                const SizedBox(height: 12),
                _buildAccordion(
                  title: 'Cuenta',
                  subtitle: null,
                  isExpanded: _cuentaExpanded,
                  onTap: () =>
                      setState(() => _cuentaExpanded = !_cuentaExpanded),
                  expandedContent: _buildCuentaContent(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: OutlinedButton(
            onPressed: () {},
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: _primaryTeal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'REDIME',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70),
                    ),
                    child: const Center(
                      child: Text(
                        '?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
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
                        child: const Icon(Icons.person, size: 40, color: Colors.white),
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
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.edit, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Nombre de\nUsuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                          style: TextStyle(fontSize: 12, color: subtitleColor),
                        ),
                      ],
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              Expanded(
                flex: 4,
                child: Text('Estado',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              Expanded(
                flex: 3,
                child: Text('Fecha',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
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
                        style: const TextStyle(fontSize: 13)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(d['estado']!,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(d['fecha']!,
                        style: const TextStyle(fontSize: 12)),
                  ),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField(label: 'Nombre', hint: 'Tu nombre'),
          const SizedBox(height: 12),
          _buildTextField(label: 'Correo electrónico', hint: 'tu@email.com'),
          const SizedBox(height: 12),
          _buildTextField(label: 'Teléfono', hint: 'Tu número'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryTeal,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Guardar cambios',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCuentaContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline, color: Colors.black54),
            title: const Text('Cambiar contraseña',
                style: TextStyle(fontSize: 14)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
            title: const Text('Eliminar cuenta',
                style: TextStyle(fontSize: 14, color: Colors.redAccent)),
            trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}