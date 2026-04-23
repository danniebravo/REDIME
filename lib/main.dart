import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/RegisterUser_viewmodel.dart';

import 'viewmodels/qr_scan_viewmodel.dart'; // esto es para poder ver mi pantalla, juan buitrago
import 'views/qr_scan_view.dart'; // esto es para poder ver mi pantalla, juan buitrago

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterUserViewModel()),
        ChangeNotifierProvider(create: (_) => QrScanViewModel()),
      ],
      child: MyApp(),
    ),

    // Proveedor global del ViewModel
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: '/login',     //La comenté para poder iniciar por mi pantalla, juan buitrago
      initialRoute: '/qr',
      routes: {
        '/register': (context) => RegisterView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/qr': (context) =>
            const QrScanView(), //agregué esto para poder ejecutar mi pantalla, juan buitrago
      },

      debugShowCheckedModeBanner: false, // opcional, quita el banner de debug
      title: 'APP REDIME',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
