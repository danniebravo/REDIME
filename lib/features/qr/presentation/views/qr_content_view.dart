import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../data/models/qr_scan_model.dart';

class QrContentView extends StatelessWidget {
  const QrContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final QrScanModel? qrData = args is QrScanModel ? args : null;

    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: AppBar(
        title: const Text('Contenido QR'),
        centerTitle: true,
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: qrData == null
            ? _EmptyQrContent(
                onScanAgain: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.qrScan);
                },
              )
            : _QrContentBody(qrData: qrData),
      ),
    );
  }
}

class _QrContentBody extends StatelessWidget {
  final QrScanModel qrData;

  const _QrContentBody({required this.qrData});

  bool get _isValidUrl {
    final uri = Uri.tryParse(qrData.rawValue.trim());

    if (uri == null) return false;

    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _openQrLink(BuildContext context) async {
    final uri = Uri.tryParse(qrData.rawValue.trim());

    if (uri == null || !_isValidUrl) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El contenido leído no es un enlace válido.'),
        ),
      );
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace.')),
      );
    }
  }

  void _scanAnotherCode(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.qrScan);
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidLink = _isValidUrl;

    final String title = isValidLink
        ? 'Código QR detectado'
        : 'Código QR no detectado';

    final String message = isValidLink
        ? 'Este código fue leído correctamente. Toca el botón "Ir al enlace" '
              'para abrir el contenido detectado, o usa "Escanear otro código" '
              'si deseas leer un nuevo código QR.'
        : 'Este código no fue leído correctamente. Toca el botón '
              '"Escanear otro código" si deseas escanear de nuevo el código QR '
              'o escanear otro código QR.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isValidLink ? Icons.check_circle : Icons.warning_rounded,
          size: 56,
          color: isValidLink ? AppColors.primaryTeal : Colors.orange,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Contenido leído:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            qrData.rawValue,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isValidLink ? () => _openQrLink(context) : null,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ir al enlace'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _scanAnotherCode(context),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Escanear otro código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyQrContent extends StatelessWidget {
  final VoidCallback onScanAgain;

  const _EmptyQrContent({required this.onScanAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_2, size: 64, color: Colors.black38),
          const SizedBox(height: 16),
          const Text(
            'No hay contenido QR para mostrar.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onScanAgain,
            child: const Text('Volver al scanner'),
          ),
        ],
      ),
    );
  }
}
