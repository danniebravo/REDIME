import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/views/login_view.dart';
import 'presentation/views/register_view.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/views/chat_view.dart';
import 'features/profile/profile_view.dart';

import 'presentation/viewmodels/login_viewmodel.dart';
import 'presentation/viewmodels/register_user_viewmodel.dart';

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
      initialRoute: '/login',
      routes: {
        '/register': (context) => RegisterView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeScreen(),
        '/chat': (context) => ChatView(),
        '/profile': (context) => ProfileView(), // ✅ ruta agregada
      },
      debugShowCheckedModeBanner: false,
      title: 'LOGIN REDIME',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}