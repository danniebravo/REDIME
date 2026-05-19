import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../features/qr/presentation/viewmodels/qr_scan_viewmodel.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  late final MobileScannerController _scannerController;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrScanViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleTorch() {
    _scannerController.toggleTorch();

    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _handleDetect(BarcodeCapture capture) {
    final viewModel = context.read<QrScanViewModel>();

    if (viewModel.hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;

    viewModel.processScannedCode(rawValue);

    final qrData = viewModel.qrData;

    if (qrData == null) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.qrContent,
      arguments: qrData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QrScanViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: AppColors.mintBackground,
          appBar: AppBar(
            title: const Text('Escanear código QR'),
            centerTitle: true,
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: _isTorchOn ? 'Apagar linterna' : 'Encender linterna',
                onPressed: _toggleTorch,
                icon: Icon(
                  _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _handleDetect,
                    ),
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(160),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          viewModel.statusMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        size: 42,
                        color: AppColors.primaryTeal,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ubica el código dentro del recuadro',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        viewModel.errorMessage ??
                            'Puedes activar la linterna si el ambiente está oscuro.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: viewModel.errorMessage == null
                              ? Colors.black54
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
