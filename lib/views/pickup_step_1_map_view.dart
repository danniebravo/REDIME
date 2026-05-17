import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/stepper_widget.dart';
import '../core/constants/app_routes.dart';

class PickupStep1MapView extends StatefulWidget {
  const PickupStep1MapView({super.key});

  @override
  State<PickupStep1MapView> createState() => _PickupStep1MapViewState();
}

class _PickupStep1MapViewState extends State<PickupStep1MapView> {
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();

  final LatLng _mockUserLocation = const LatLng(6.255, -75.58);

  bool _showSearchBar = false;
  bool _routeCalculated = false;

  void _onRequestRoute() {
    setState(() => _showSearchBar = true);
  }

  void _onSubmitAddress() {
    if (_addressController.text.trim().isNotEmpty) {
      setState(() {
        _routeCalculated = true;
        _showSearchBar = false;
      });
    }
  }

  void _onClearAddress() {
    _addressController.clear();
    setState(() {
      _routeCalculated = false;
      _showSearchBar = false;
    });
  }

  void _onDeselectPoint() {
    _onClearAddress();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F1E8),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // MAPA (sin lógica dinámica)
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(6.2442, -75.5812),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.redime.app',
                ),
              ],
            ),
          ),

          // HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title: 'REDIME',
              backgroundColor: AppColors.primaryTeal.withAlpha(242),
              titleColor: AppColors.white,
              showBackButton: true,
              bottomWidget: (_showSearchBar || _routeCalculated)
                  ? _buildSearchBar()
                  : null,
            ),
          ),

          // BOTTOM PANEL SIMPLIFICADO
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomPanel()),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      color: AppColors.primaryTeal.withAlpha(242),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StepperWidget(currentStep: 1, activeColor: AppColors.white),
          const SizedBox(height: 16),

          const Text(
            'Selecciona un punto de reciclaje',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: 'Continuar',
            isEnabled: _routeCalculated,
            onPressed: _routeCalculated
                ? () {
                    Navigator.pushNamed(context, AppRoutes.pickupStep2);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkestTeal.withAlpha(235),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: _addressController,
              cursorColor: AppColors.white,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: 'Ingresa tu dirección...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _onSubmitAddress(),
            ),
          ),

          GestureDetector(
            onTap: _routeCalculated ? _onClearAddress : _onSubmitAddress,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.teal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _routeCalculated ? Icons.close : Icons.arrow_forward,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
