import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/RegisterUser_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterUserViewModel()),
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
      initialRoute: '/login',
      routes: {
        '/register': (context) => RegisterView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),

      },

      debugShowCheckedModeBanner: false, // opcional, quita el banner de debug
      title: 'APP REDIME',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
