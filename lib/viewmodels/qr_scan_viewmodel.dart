import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';

class QrScanViewModel extends ChangeNotifier {
  bool _isScanning = false;
  bool get isScanning => _isScanning;

  String _statusMessage = 'Presiona el botón para escanear el código QR.';
  String get statusMessage => _statusMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  QrScanModel? _qrData;
  QrScanModel? get qrData => _qrData;

  void initialize() {
    _isScanning = false;
    _statusMessage = 'Presiona el botón para escanear el código QR.';
    _errorMessage = null;
    _qrData = null;
    notifyListeners();
  }

  Future<void> startScan() async {
    if (_isScanning) return;

    _isScanning = true;
    _errorMessage = null;
    _statusMessage = 'Escaneando código QR...';
    notifyListeners();

    try {
      // simulación de escaneo
      await Future.delayed(const Duration(seconds: 2));

      _qrData = QrScanModel(
        url: 'https://www.shutterstock.com',
        title: 'Personaje de prueba',
        description: 'Contenido simulado del QR.',
      );

      _statusMessage = 'Código QR detectado correctamente.';
    } catch (e) {
      _errorMessage = 'Error al escanear el código.';
      _statusMessage = 'Intenta nuevamente.';
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  void reset() {
    initialize();
  }
}
