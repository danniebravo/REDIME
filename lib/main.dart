import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/welcome_view.dart';
import 'views/profile_view.dart';
import 'views/delete_account_view.dart';
import 'views/chat_view.dart';
import 'views/qr_scan_view.dart';
import 'views/qr_content_view.dart';
import 'views/device_status_view.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/RegisterUser_viewmodel.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

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
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeView(),
        AppRoutes.register: (context) => RegisterView(),
        AppRoutes.login: (context) => LoginView(),
        AppRoutes.home: (context) => HomeView(),
        AppRoutes.profile: (context) => ProfileView(),
        AppRoutes.deleteAccount: (context) => const DeleteAccountView(),
        AppRoutes.chat: (context) => const ChatView(),
        AppRoutes.qrScan: (context) => const QrScanView(),
        AppRoutes.qrContent: (context) => const QrContentView(),
        AppRoutes.deviceStatus: (context) => const DeviceStatusView(),
      },

      debugShowCheckedModeBanner: false, // opcional, quita el banner de debug
      title: 'APP REDIME',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
