import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/help_button.dart';
import '../models/user_model.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const Color _primaryColor = Color(0xFF3A8F7D);
  static const Color _backgroundColor = Color(0xFFF5F5F0);

  static String _photoPrefKey(int userId) => 'profile_photo_path_$userId';

  String? _localPhotoPath;
  int? _photoLoadedForUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadUser();
    });
  }

  Future<void> _loadLocalPhotoFor(int userId) async {
    _photoLoadedForUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_photoPrefKey(userId));
    if (!mounted) return;
    setState(() {
      _localPhotoPath = (path != null && File(path).existsSync()) ? path : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<HomeViewModel>().user;
    if (user != null && user.id != _photoLoadedForUserId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadLocalPhotoFor(user.id);
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _HomeHeader(
                      localPhotoPath: _localPhotoPath,
                      onSupportTap: () {
                        Navigator.pushNamed(context, AppRoutes.chat);
                      },
                      onProfileTap: () {
                        Navigator.pushNamed(context, AppRoutes.profile).then((_) {
                          if (!mounted) return;
                          context.read<HomeViewModel>().loadUser();
                          _photoLoadedForUserId = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _HomeActionButton(
                            icon: Icons.local_shipping,
                            label: 'Recoger dispositivos',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.pickupFlow,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _HomeActionButton(
                            icon: Icons.location_on,
                            label: 'Ver puntos de reciclaje',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.pickupStep1,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _HomeActionButton(
                            icon: Icons.monitor_heart,
                            label: 'Estado del dispositivo',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.deviceStatus,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Novedades',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Hoy',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 170,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 20, right: 6),
                        children: const [
                          _NewsCard(
                            title: 'Museo ITM',
                            subtitle: 'Nueva exposición de memorias RAEE',
                            icon: Icons.museum,
                            url:
                                'https://redime.elsalseo.site/blog/yp4Nf4HmT8ZbAx0umdCO',
                          ),
                          _NewsCard(
                            title: 'Meta Medellín',
                            subtitle: 'Seguimos recuperando tecnología',
                            icon: Icons.eco,
                            url:
                                'https://redime.elsalseo.site/blog/Yt45MlK7Bu6envr21LSM',
                          ),
                          _NewsCard(
                            title: 'Trazabilidad',
                            subtitle: 'Consulta el estado de tus dispositivos',
                            icon: Icons.timeline,
                            url:
                                'https://redime.elsalseo.site/blog/jGHLOlf8W3o87t5EIYI1',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _HomeBottomNavigation(
          onHomeTap: () {},
          onQrTap: () {
            Navigator.pushNamed(context, AppRoutes.qrScan);
          },
          onProfileTap: () {
            Navigator.pushNamed(context, AppRoutes.profile).then((_) {
              if (!mounted) return;
              context.read<HomeViewModel>().loadUser();
              _photoLoadedForUserId = null;
            });
          },
        ),
      ),
    );
  }
}

class _HomeHeaderClipper extends CustomClipper<Path> {
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

class _HomeHeader extends StatelessWidget {
  final VoidCallback onSupportTap;
  final VoidCallback onProfileTap;
  final String? localPhotoPath;

  const _HomeHeader({
    required this.onSupportTap,
    required this.onProfileTap,
    this.localPhotoPath,
  });

  static const Color _primaryColor = Color(0xFF3A8F7D);
  static const Color _softGreen = Color(0xFFE7F0EE);

  Widget _buildAvatar(UserModel? user) {
    if (localPhotoPath != null && File(localPhotoPath!).existsSync()) {
      return Image.file(
        File(localPhotoPath!),
        fit: BoxFit.cover,
        width: 82,
        height: 82,
      );
    }
    final url = user?.photoUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: 82,
        height: 82,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.person,
          size: 46,
          color: _primaryColor,
        ),
      );
    }
    return const Icon(Icons.person, size: 46, color: _primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HomeHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: _primaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 66),
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
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
                        onPressed: onSupportTap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: onProfileTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: const BoxDecoration(
                            color: _softGreen,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Builder(
                            builder: (context) {
                              final user =
                                  context.watch<HomeViewModel>().user;
                              return _buildAvatar(user);
                            },
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Builder(
                                builder: (context) {
                                  final user = context.watch<HomeViewModel>().user;
                                  if (user == null) {
                                    return const Text(
                                      'Cargando...',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    );
                                  }
                                  final display = user.nombreUsuario.isNotEmpty
                                      ? user.nombreUsuario
                                      : (user.nombreCompleto.isNotEmpty
                                          ? user.nombreCompleto
                                          : 'Sin nombre');
                                  return Text(
                                    display,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.1,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Ver perfil y cuenta',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xFF3A8F7D);
  static const Color _softGreen = Color(0xFFE7F0EE);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _softGreen,
                child: Icon(icon, color: _primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? url;

  const _NewsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.url,
  });

  Future<void> _open(BuildContext context) async {
    final raw = url;
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.parse(raw);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _open(context),
          child: Ink(
            width: 200,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF2F7168), Color(0xFF1F4D48)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 56),
                const SizedBox(height: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBottomNavigation extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onQrTap;
  final VoidCallback onProfileTap;

  const _HomeBottomNavigation({
    required this.onHomeTap,
    required this.onQrTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavItem(icon: Icons.home, isActive: true, onTap: onHomeTap),
          _BottomNavItem(
            icon: Icons.qr_code_scanner,
            isActive: false,
            onTap: onQrTap,
          ),
          _BottomNavItem(
            icon: Icons.person,
            isActive: false,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xFF3A8F7D);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: isActive ? _primaryColor : Colors.grey, size: 29),
    );
  }
}
