import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/help_button.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';

class StoryThanksData {
  final String? story;
  final String? imagePath;
  final String? subcategory;
  final String? brand;
  final String? age;

  const StoryThanksData({
    this.story,
    this.imagePath,
    this.subcategory,
    this.brand,
    this.age,
  });

  bool get hasImage {
    final p = imagePath;
    if (p == null || p.isEmpty) return false;
    return File(p).existsSync();
  }
}

class PickupStoryThanksView extends StatefulWidget {
  const PickupStoryThanksView({super.key});

  @override
  State<PickupStoryThanksView> createState() => _PickupStoryThanksViewState();
}

class _PickupStoryThanksViewState extends State<PickupStoryThanksView> {
  StoryThanksData? _data;
  UserModel? _user;
  bool _sharing = false;

  static const String _hashtag = '#capsulasdememoriamed';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data ??= (ModalRoute.of(context)?.settings.arguments as StoryThanksData?) ??
        const StoryThanksData();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (_user != null) return;
    try {
      final user = await AuthService().getProfile();
      if (!mounted) return;
      setState(() => _user = user);
    } catch (_) {}
  }

  Future<void> _shareStory() async {
    if (_sharing) return;
    final story = (_data?.story ?? '').trim();
    final text = story.isEmpty
        ? 'Acabo de redimir mi dispositivo en REDIME. $_hashtag'
        : '$story\n\n$_hashtag';

    setState(() => _sharing = true);
    try {
      final imagePath = _data?.imagePath;
      if (imagePath != null && File(imagePath).existsSync()) {
        await Share.shareXFiles([XFile(imagePath)], text: text);
      } else {
        await Share.share(text);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el compartir')),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  void _goHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _data?.hasImage ?? false;
    return hasImage ? _buildWithCard(context) : _buildSimple(context);
  }

  // ──────────────── CON foto: card compartible ────────────────
  Widget _buildWithCard(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const _ThanksHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/Logocheck.png',
                        width: 130,
                        height: 130,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primaryTeal,
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¡Rescate iniciado!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Gracias por confiar en Redime para dar\nuna segunda vida a tu dispositivo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkTeal,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _StoryCard(
                      userName:
                          _user?.nombreCompleto.trim().isNotEmpty == true
                              ? _user!.nombreCompleto
                              : (_user?.nombreUsuario ?? 'Usuario'),
                      brandLabel: _data?.brand?.trim().isNotEmpty == true
                          ? _data!.brand!.trim()
                          : (_data?.subcategory ?? '—'),
                      ageLabel: _data?.age ?? '',
                      story: _data?.story ?? '',
                      imagePath: _data?.imagePath,
                      hashtag: _hashtag,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goHome,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.black26),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Volver al inicio'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _sharing ? null : _shareStory,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Color(0xFFD1D5DB),
                                    width: 1,
                                  ),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Compartir en redes',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.share, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Si quieres ver más historias,',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' publica tu historia con el botón de aquí y se creará un post automático con tu historia, foto y el ',
                          ),
                          const TextSpan(
                            text: _hashtag,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(
                            text:
                                '; en este hashtag se encuentran las historias de más personas que quisieron redimir sus dispositivos.',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────── SIN foto: rediseño simple ────────────────
  Widget _buildSimple(BuildContext context) {
    const mint = Color(0xFF9CC4B5);
    const darkGreen = Color(0xFF2E5E54);
    const titleColor = Color(0xFF1F2933);
    const subtitleColor = Color(0xFF6B7280);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: mint,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const _SimpleHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/Logocheck.png',
                        width: 130,
                        height: 130,
                        errorBuilder: (_, __, ___) => Container(
                          width: 130,
                          height: 130,
                          decoration: const BoxDecoration(
                            color: mint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: darkGreen,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '¡Rescate iniciado!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gracias por confiar en Redime para dar\nuna segunda vida a tu dispositivo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: subtitleColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 240,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: darkGreen.withValues(alpha: 0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _goHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Volver al inicio',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String userName;
  final String brandLabel;
  final String ageLabel;
  final String story;
  final String? imagePath;
  final String hashtag;

  const _StoryCard({
    required this.userName,
    required this.brandLabel,
    required this.ageLabel,
    required this.story,
    required this.imagePath,
    required this.hashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkTeal,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  child: (imagePath != null && File(imagePath!).existsSync())
                      ? Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                        )
                      : const Icon(
                          Icons.photo_outlined,
                          color: Colors.white54,
                          size: 36,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardField(label: 'De:', value: userName),
                    const SizedBox(height: 10),
                    _CardField(label: 'Marca:', value: brandLabel),
                    const SizedBox(height: 10),
                    _CardField(label: 'Antigüedad:', value: ageLabel),
                  ],
                ),
              ),
            ],
          ),
          if (story.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              story,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              hashtag,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  final String label;
  final String value;

  const _CardField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? '—' : value,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _SimpleHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 48);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 48,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _SimpleHeader extends StatelessWidget {
  const _SimpleHeader();

  @override
  Widget build(BuildContext context) {
    const headerBg = Color(0xFF2E7D6B);

    return ClipPath(
      clipper: _SimpleHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: headerBg,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 48),
            child: Column(
              children: [
                SizedBox(
                  height: 54,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 7,
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.chat),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '¡Gracias!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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

class _ThanksHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 38);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 2,
      size.width,
      size.height - 38,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ThanksHeader extends StatelessWidget {
  const _ThanksHeader();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ThanksHeaderClipper(),
      child: Container(
        width: double.infinity,
        color: AppColors.primaryTeal,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
            child: Column(
              children: [
                SizedBox(
                  height: 54,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'REDIME',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 7,
                        child: HelpButton(
                          size: 40,
                          iconSize: 20,
                          borderWidth: 2,
                          color: AppColors.white,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.chat);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '¡Gracias!',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
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
