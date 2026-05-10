import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class QrScanModel {
  final String title;
  final String description;
  final String rawValue;

  QrScanModel({
    required this.title,
    required this.description,
    required this.rawValue,
  });
}

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
            ? _EmptyQrContent(onScanAgain: () => Navigator.pop(context))
            : _QrContentBody(qrData: qrData),
      ),
    );
  }
}

class _QrContentBody extends StatelessWidget {
  final QrScanModel qrData;

  const _QrContentBody({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 56, color: AppColors.primaryTeal),

        const SizedBox(height: 20),

        Text(
          qrData.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Text(
          qrData.description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Contenido leído:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Escanear otro código'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
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

          ElevatedButton(onPressed: onScanAgain, child: const Text('Volver')),
        ],
      ),
    );
  }
}
