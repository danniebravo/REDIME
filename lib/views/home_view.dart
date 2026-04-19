import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 260,
        leading: Row(
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
        title: Padding(
          padding: const EdgeInsets.only(bottom: 130),
          child: Text('REDIME'),
        ),
        toolbarHeight: 190,
        backgroundColor: AppColors.primaryTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 34),
          ExpansionTile(
            title: Text('Dispositivos Redimidos'),
            children: [
              ListTile(
                leading:
                    Icon(Icons.local_shipping, color: AppColors.primaryTeal),
                title: Text('Recoger dispositivo'),
                subtitle: Text('Inicia el proceso de reciclaje'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.pickupFlow),
              ),
              ListTile(
                leading:
                    Icon(Icons.track_changes, color: AppColors.primaryTeal),
                title: Text('Estado del dispositivo'),
                subtitle: Text('Consulta el seguimiento'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.deviceStatus),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Tu Informaci\u00f3n'),
            children: [
              ListTile(title: Text('Opci\u00f3n 1')),
            ],
          ),
          ExpansionTile(
            title: Text('Cuenta'),
            children: [
              ListTile(title: Text('Opci\u00f3n 1')),
            ],
          ),
        ],
      ),
    );
  }
}
