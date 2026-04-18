import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/profile_view.dart'; // ✅ importación correcta

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
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/register': (context) => RegisterView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/profile': (context) => ProfileView(), // ✅ ruta agregada
      },
      debugShowCheckedModeBanner: false,
      title: 'LOGIN REDIME',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}