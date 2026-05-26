import 'package:flutter/material.dart';

import '../../data/models/qr_scan_model.dart';

class QrScanViewModel extends ChangeNotifier {
  bool _hasScanned = false;
  bool get hasScanned => _hasScanned;

  String _statusMessage = 'Apunta la cámara hacia el código QR.';
  String get statusMessage => _statusMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  QrScanModel? _qrData;
  QrScanModel? get qrData => _qrData;

  void initialize() {
    _hasScanned = false;
    _statusMessage = 'Apunta la cámara hacia el código QR.';
    _errorMessage = null;
    _qrData = null;
    notifyListeners();
  }

  void processScannedCode(String? rawValue) {
    if (_hasScanned) return;

    if (rawValue == null || rawValue.trim().isEmpty) {
      _errorMessage = 'No se pudo leer el contenido del QR.';
      _statusMessage = 'Intenta acercar o enfocar mejor el código.';
      notifyListeners();
      return;
    }

    _hasScanned = true;
    _errorMessage = null;
    _qrData = QrScanModel.fromRawValue(rawValue.trim());
    _statusMessage = 'Código QR detectado correctamente.';
    notifyListeners();
  }

  void resetScanner() {
    initialize();
  }
}
