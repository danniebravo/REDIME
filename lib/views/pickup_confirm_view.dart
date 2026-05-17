import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/widgets/custom_app_bar.dart';

class PickupConfirmView extends StatefulWidget {
  const PickupConfirmView({super.key});

  @override
  State<PickupConfirmView> createState() => _PickupConfirmViewState();
}

class _PickupConfirmViewState extends State<PickupConfirmView> {
  final GlobalKey _cardKey = GlobalKey();

  // Mock data temporal hasta conectar ViewModel/backend
  final bool _hasStory = true;

  final String _storyText =
      'Este fue mi primer celular y me acompañó durante muchos años.';

  final String _deviceType = 'Teléfono';
  final String _brandName = 'Samsung';
  final String _age = '5 años';
  final String _userName = 'Usuario';
  final Uint8List? _imageBytes = null;

  void _shareCard() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '📤 Compartir en redes sociales (se integrará con share_plus)',
        ),
        backgroundColor: AppColors.darkTeal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'REDIME',
        showBackButton: _hasStory,
        backgroundColor: AppColors.darkTeal.withValues(alpha: 0.95),
        titleColor: AppColors.white,
        bottomWidget: const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(
            '¡Gracias!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _hasStory ? _buildStoryLayout() : _buildSkipLayout(),
      ),
    );
  }

  Widget _buildSkipLayout() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logocheck.png',
              height: 140,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 28),

            const Text(
              '¡Rescate iniciado!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Gracias por confiar en Redime para dar\nuna segunda vida a tu dispositivo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkestTeal,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 36),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkTeal,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Volver al inicio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          Image.asset(
            'assets/images/Logocheck.png',
            height: 110,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 20),

          const Text(
            '¡Rescate iniciado!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Gracias por confiar en Redime para dar\nuna segunda vida a tu dispositivo.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.darkestTeal,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          _buildShareableCard(),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.home,
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkTeal,
                    side: const BorderSide(color: AppColors.darkTeal),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Volver al inicio',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _shareCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkTeal,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Compartir en redes',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.share, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: AppColors.darkestTeal,
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: 'Si quieres ver más historias, ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'publica tu historia con el botón de aquí y se creará un post automático con tu historia, foto y el ',
                ),
                TextSpan(
                  text: '#capsulasdememoriamed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      '; en este hashtag se encuentran las historias de más personas que quisieron redimir sus dispositivos.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildShareableCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: RepaintBoundary(
          key: _cardKey,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkestTeal,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: _imageBytes != null
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : Container(
                            color: AppColors.darkTeal,
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.lightTeal,
                              size: 48,
                            ),
                          ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'De:',
                                  style: TextStyle(
                                    color: AppColors.teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  _userName,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Antigüedad:',
                                style: TextStyle(
                                  color: AppColors.teal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                _age,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '$_deviceType:',
                        style: const TextStyle(
                          color: AppColors.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        _brandName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Container(
                    height: 1,
                    color: AppColors.teal.withValues(alpha: 0.3),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    _storyText,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '#capsulasdememoriamed',
                      style: TextStyle(
                        color: AppColors.teal.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
