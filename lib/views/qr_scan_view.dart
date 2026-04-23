import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/qr_scan_viewmodel.dart';
import 'qr_content_view.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrScanViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QrScanViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Expanded(
                    child: Text(
                      'Scan de QR',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // CUADRO QR
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: vm.isScanning
                      ? const Color(0xFF2F7F7A)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(Icons.qr_code_2, size: 100, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            Icon(
              vm.isScanning
                  ? Icons.qr_code_scanner
                  : vm.qrData != null
                  ? Icons.check_circle
                  : Icons.qr_code,
              size: 40,
              color: vm.errorMessage != null
                  ? Colors.red
                  : const Color(0xFF2F7F7A),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                vm.errorMessage ?? vm.statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: vm.errorMessage != null ? Colors.red : Colors.black87,
                ),
              ),
            ),

            const Spacer(),

            // BOTÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: vm.isScanning
                      ? null
                      : () async {
                          await vm.startScan();

                          if (!mounted) return;

                          if (vm.qrData != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    QrContentView(qrData: vm.qrData!),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F7F7A),
                  ),
                  child: vm.isScanning
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Escanear código'),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
