import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/primary_button.dart';
import '../core/widgets/stepper_widget.dart';
import '../core/constants/app_routes.dart';
import '../features/device_pickup/presentation/viewmodels/pickup_viewmodel.dart';

class PickupStep1MapView extends StatefulWidget {
  const PickupStep1MapView({super.key});

  @override
  State<PickupStep1MapView> createState() => _PickupStep1MapViewState();
}

class _PickupStep1MapViewState extends State<PickupStep1MapView> {
  final PickupViewModel _viewModel = PickupViewModel();
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();

  final LatLng _mockUserLocation = const LatLng(6.255, -75.58);
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _viewModel.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {
      if (_viewModel.isRouteCalculated && _viewModel.selectedPoint != null) {
        _mapController.move(
          LatLng(
            (_mockUserLocation.latitude +
                    _viewModel.selectedPoint!.location.latitude) /
                2,
            (_mockUserLocation.longitude +
                    _viewModel.selectedPoint!.location.longitude) /
                2,
          ),
          13.5,
        );
      } else if (_viewModel.isPointSelected &&
          _viewModel.selectedPoint != null) {
        _mapController.move(_viewModel.selectedPoint!.location, 15.0);
      }
    });
  }

  void _onRequestRoute() {
    setState(() => _showSearchBar = true);
  }

  void _onSubmitAddress() {
    if (_addressController.text.trim().isNotEmpty) {
      _viewModel.setUserAddress(_addressController.text.trim());
      _viewModel.calculateRoute();
    }
  }

  void _onClearAddress() {
    _addressController.clear();
    _viewModel.setUserAddress('');
    _viewModel.isRouteCalculated = false;
    setState(() => _showSearchBar = false);
    _viewModel.notifyListeners();
  }

  void _onDeselectPoint() {
    _viewModel.deselectPoint();
    _addressController.clear();
    setState(() => _showSearchBar = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F1E8),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. Mapa
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
                if (_viewModel.isRouteCalculated &&
                    _viewModel.selectedPoint != null)
                  PolylineLayer(
                    polylines: <Polyline<Object>>[
                      Polyline<Object>(
                        points: [
                          _mockUserLocation,
                          _viewModel.selectedPoint!.location,
                        ],
                        color: AppColors.darkTeal,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    ..._viewModel.availablePoints.map((point) {
                      return Marker(
                        point: point.location,
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _viewModel.selectPoint(point),
                          child: _buildRecycleMarker(
                            isSelected:
                                _viewModel.selectedPoint?.id == point.id,
                          ),
                        ),
                      );
                    }),
                    if (_viewModel.isRouteCalculated)
                      Marker(
                        point: _mockUserLocation,
                        width: 20,
                        height: 20,
                        child: _buildUserLocationMarker(),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              title: 'REDIME',
              backgroundColor: AppColors.primaryTeal.withAlpha(242),
              titleColor: AppColors.white,
              showBackButton: true,
              bottomWidget: (_showSearchBar || _viewModel.isRouteCalculated)
                  ? _buildSearchBar()
                  : null,
            ),
          ),

          // 3. Bottom: default panel or point card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _viewModel.isPointSelected
                ? _buildPointBottomSheet()
                : _buildDefaultBottomPanel(),
          ),
        ],
      ),
    );
  }

  // ─── Default bottom panel (no point selected) ───
  Widget _buildDefaultBottomPanel() {
    return ClipPath(
      clipper: _TopCurvedClipper(),
      child: Container(
        color: AppColors.primaryTeal.withAlpha(242),
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 40,
          left: 24,
          right: 24,
        ),
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
              isEnabled: false,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ─── Point card as a bottom sheet (replaces panel) ───
  Widget _buildPointBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightTeal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkTeal.withAlpha(76),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Card content - constrained and scrollable
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.42,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _onDeselectPoint,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.darkTeal,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Punto de recolección',
                        style: TextStyle(
                          color: AppColors.darkestTeal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Dirección
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dirección ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkestTeal,
                          fontSize: 13,
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: AppColors.darkTeal,
                        size: 14,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      _viewModel.selectedPoint?.address ?? '',
                      style: const TextStyle(
                        color: AppColors.darkestTeal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dispositivos
                  const Row(
                    children: [
                      Text(
                        'Dispositivos permitidos ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkestTeal,
                          fontSize: 13,
                        ),
                      ),
                      Icon(Icons.devices, color: AppColors.darkTeal, size: 14),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      '•  Teléfonos  •  Televisores  •  Cámaras  •  Consolas',
                      style: TextStyle(
                        color: AppColors.darkestTeal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Horarios
                  const Row(
                    children: [
                      Text(
                        'Horarios ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkestTeal,
                          fontSize: 13,
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        color: AppColors.darkTeal,
                        size: 14,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      '7:00 am - 6:00 pm (Lun - Sáb)',
                      style: TextStyle(
                        color: AppColors.darkestTeal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Ruta info o botón
                  if (_viewModel.isRouteCalculated)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.darkTeal.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.directions_walk,
                                color: AppColors.darkTeal,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '2.5 km',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkestTeal,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: AppColors.darkTeal,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '10 min',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkestTeal,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onRequestRoute,
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text(
                          'Ir a la dirección',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkTeal,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Continuar button always visible
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: PrimaryButton(
              text: 'Continuar',
              isEnabled: _viewModel.isRouteCalculated,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.pickupStep2,
                  arguments: _viewModel,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ───
  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.darkestTeal.withAlpha(235),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _addressController,
              autofocus: !_viewModel.isRouteCalculated,
              onSubmitted: (_) => _onSubmitAddress(),
              cursorColor: AppColors.white,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Ingresa tu dirección...',
                hintStyle: TextStyle(
                  color: AppColors.white.withAlpha(180),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                filled: false,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (!_viewModel.isRouteCalculated)
            GestureDetector(
              onTap: _onSubmitAddress,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
          if (_viewModel.isRouteCalculated)
            GestureDetector(
              onTap: _onClearAddress,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecycleMarker({bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.darkestTeal : AppColors.darkTeal,
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: AppColors.white, width: 2)
            : null,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(
        Icons.sync,
        color: AppColors.white,
        size: isSelected ? 24 : 20,
      ),
    );
  }

  Widget _buildUserLocationMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.darkestTeal, width: 3),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.darkestTeal,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _TopCurvedClipper extends CustomClipper<ui.Path> {
  @override
  ui.Path getClip(Size size) {
    final path = ui.Path();

    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<ui.Path> oldClipper) => false;
}
