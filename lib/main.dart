import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'viewmodels/login_viewmodel.dart';


void main() {
  runApp(
    // Proveedor global del ViewModel
    ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // opcional, quita el banner de debug
      title: 'Flutter MVVM Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(), // Vista principal
    );
  }
}

