import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../viewmodels/welcome_view_model.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late final WelcomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WelcomeViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Sección superior gráfica (aprox 55% de la pantalla)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            child: Stack(
              children: [
                // Círculo Teal Superior Derecha
                Positioned(
                  top: -80,
                  right: -90,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Círculo Verde Claro Inferior Derecha
                Positioned(
                  bottom: -40,
                  right: -120,
                  child: Container(
                    width: 380,
                    height: 380,
                    decoration: const BoxDecoration(
                      color: AppColors.lightTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Círculo Verde Oscuro Izquierda
                Positioned(
                  top: -60,
                  left: -180,
                  child: Container(
                    width: 550,
                    height: 550,
                    decoration: const BoxDecoration(
                      color: AppColors.darkGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Textos sobre los círculos
                Align(
                  alignment: const Alignment(0, 0.3), // Subí un poco la alineación para dar espacio al logo
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Espacio para tu Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120, // Altura del logo
                        errorBuilder: (context, error, stackTrace) {
                          // Icono de respaldo por si aún no guardas la imagen local
                          return const Icon(
                            Icons.eco_rounded, 
                            size: 120, 
                            color: AppColors.white
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'REDIME',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sección Inferior de Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tus dispositivos tienen historia y nosotros la\npreservamos. Conoce las opciones que REDIME te\nofrece y comienza tu proceso ahora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMain,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Continuar',
                    onPressed: () => _viewModel.onContinue(context),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
