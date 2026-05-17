import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/primary_button.dart';

class PickupStep2TypeView extends StatefulWidget {
  const PickupStep2TypeView({super.key});

  @override
  State<PickupStep2TypeView> createState() => _PickupStep2TypeViewState();
}

class _PickupStep2TypeViewState extends State<PickupStep2TypeView> {
  String? _selectedCategory;

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  bool get _canContinue => _selectedCategory != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'REDIME', currentStep: 2),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              const Text(
                'Empecemos\ncon la redención',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                '¿Selecciona qué tipo de dispositivo deseas\nreciclar hoy?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.darkTeal),
              ),

              const SizedBox(height: 48),

              Row(
                children: [
                  Expanded(
                    child: _buildCategoryCard(
                      categoryKey: 'telecom',
                      title: 'Equipos de\ntelecomunicaciones',
                      imageSelected:
                          'assets/images/Equipos-de-telecom-seleccionados.webp',
                      imageUnselected:
                          'assets/images/Equipos-de-telecom-deseleccionado_1.webp',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCategoryCard(
                      categoryKey: 'others',
                      title: 'Otros',
                      imageSelected:
                          'assets/images/Otros-celeccionado_-blanco_1.webp',
                      imageUnselected:
                          'assets/images/Otros-deseleccionados_-negro.webp',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              PrimaryButton(
                text: 'Continuar',
                isEnabled: _canContinue,
                onPressed: _canContinue
                    ? () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.pickupStep3,
                          arguments: _selectedCategory,
                        );
                      }
                    : null,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String categoryKey,
    required String title,
    required String imageSelected,
    required String imageUnselected,
  }) {
    final isSelected = _selectedCategory == categoryKey;

    Color bgColor;
    Color textColor;

    if (!isSelected) {
      bgColor = categoryKey == 'telecom'
          ? AppColors.lightTeal
          : AppColors.white;

      textColor = categoryKey == 'telecom'
          ? AppColors.darkTeal
          : AppColors.textMain;
    } else {
      bgColor = categoryKey == 'telecom'
          ? AppColors.darkTeal
          : AppColors.otherSelectedBg;

      textColor = categoryKey == 'telecom'
          ? AppColors.lightTeal
          : AppColors.white;
    }

    return GestureDetector(
      onTap: () => _selectCategory(categoryKey),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  isSelected ? imageSelected : imageUnselected,
                  height: 64,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          if (isSelected)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
