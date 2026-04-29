import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 250,
        leading: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle, color: Colors.white, size: 90.0),
            SizedBox(width: 8),
            Text(
              'Nombre de usuario',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 130),
          child: Text('REDIME'),
        ),
        toolbarHeight: 190,
        backgroundColor: const Color.fromARGB(255, 65, 141, 204),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 34),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Escanear código QR'),
              subtitle: const Text(
                'Lee el código de una tarjeta, historia o dispositivo REDIME.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.qrScan);
              },
            ),
          ),

          const SizedBox(height: 12),

          const ExpansionTile(
            title: Text("Dispositivos Redimidos"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
          const ExpansionTile(
            title: Text("Tu Información"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
          const ExpansionTile(
            title: Text("Cuenta"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
        ],
      ),
    );
  }
}
