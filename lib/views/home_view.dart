import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/gestures.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 250,
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
          padding: const EdgeInsets.only(
            bottom: 130,
          ), // empuja el texto hacia arriba
          child: Text('REDIME'),
        ),
        toolbarHeight: 190,
        backgroundColor: const Color.fromARGB(255, 65, 141, 204),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
        ),

        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),

      body: ListView(
        children: [
          SizedBox(height: 34),
          ExpansionTile(
            title: Text("Dispositivos Redimidos"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
          ExpansionTile(
            title: Text("Tu Información"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
          ExpansionTile(
            title: Text("Cuenta"),
            children: [ListTile(title: Text('Opción 1'))],
          ),
        ],
      ),
    );
  }
}
