import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const Color _primaryColor = Color(0xFF3A8F7D);
  static const Color _backgroundColor = Color(0xFFF5F5F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        toolbarHeight: 170,
        backgroundColor: _primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        title: const Text(
          'REDIME',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Soporte',
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),
        ],
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 58),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                  child: const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Nombre de usuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          const Text(
            '¿Qué quieres hacer hoy?',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gestiona tus dispositivos, consulta su trazabilidad o accede a soporte.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 20),

          _HomeActionCard(
            icon: Icons.person,
            title: 'Mi perfil',
            subtitle: 'Consulta y actualiza tu información personal.',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          const SizedBox(height: 12),

          _HomeActionCard(
            icon: Icons.local_shipping,
            title: 'Recoger dispositivo',
            subtitle: 'Registra una solicitud de recogida o entrega.',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.pickupFlow);
            },
          ),
          const SizedBox(height: 12),

          _HomeActionCard(
            icon: Icons.monitor_heart,
            title: 'Estado del dispositivo',
            subtitle: 'Consulta el avance y trazabilidad del proceso.',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.deviceStatus);
            },
          ),
          const SizedBox(height: 12),

          _HomeActionCard(
            icon: Icons.qr_code_scanner,
            title: 'Escanear código QR',
            subtitle: 'Lee el código de una tarjeta, historia o dispositivo.',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.qrScan);
            },
          ),
          const SizedBox(height: 12),

          _HomeActionCard(
            icon: Icons.support_agent,
            title: 'Soporte REDIME',
            subtitle:
                'Resuelve dudas sobre reciclaje, recogida o trazabilidad.',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.chat);
            },
          ),

          const SizedBox(height: 24),

          const _HomeSectionTitle(title: 'Mi cuenta'),

          const SizedBox(height: 8),

          ExpansionTile(
            title: const Text('Dispositivos Redimidos'),
            subtitle: const Text('Historial de dispositivos registrados'),
            children: [
              ListTile(
                title: const Text('Ver mi perfil'),
                subtitle: const Text(
                  'Consulta tus dispositivos redimidos desde tu perfil.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Tu Información'),
            subtitle: const Text('Datos básicos del usuario'),
            children: [
              ListTile(
                title: const Text('Editar información personal'),
                subtitle: const Text(
                  'Actualiza nombre, celular y correo en tu perfil.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Cuenta'),
            subtitle: const Text('Configuración y cierre de sesión'),
            children: [
              ListTile(
                title: const Text('Administrar cuenta'),
                subtitle: const Text(
                  'Cerrar sesión o solicitar eliminación de cuenta.',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xFF3A8F7D);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFE7F0EE),
          child: Icon(icon, color: _primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 13, height: 1.3),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _HomeSectionTitle extends StatelessWidget {
  final String title;

  const _HomeSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}
