import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'features/device_pickup/domain/usecases/submit_pickup_request.dart';
import 'features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';

import 'viewmodels/RegisterUser_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';

import 'views/chat_view.dart';
import 'views/delete_account_view.dart';
import 'views/device_status_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/pickup_confirm_view.dart';
import 'views/pickup_confirmation_view.dart';
import 'views/pickup_flow_page.dart';
import 'views/pickup_step_1_map_view.dart';
import 'views/pickup_step_2_type_view.dart';
import 'views/pickup_step_3_details_view.dart';
import 'views/pickup_step_4_story_view.dart';
import 'views/profile_view.dart';
import 'views/qr_content_view.dart';
import 'views/qr_scan_view.dart';
import 'views/register_view.dart';
import 'views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterUserViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Bypass temporal solo para pruebas visuales.
  // Mantener en false antes de subir cambios finales.
  static const bool bypassLogin = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: bypassLogin ? AppRoutes.home : AppRoutes.welcome,
      debugShowCheckedModeBanner: false,
      title: 'APP REDIME',
      theme: AppTheme.lightTheme,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeView(),
        AppRoutes.register: (context) => RegisterView(),
        AppRoutes.login: (context) => LoginView(),
        AppRoutes.home: (context) => const HomeView(),
        AppRoutes.profile: (context) => const ProfileView(),
        AppRoutes.deleteAccount: (context) => const DeleteAccountView(),
        AppRoutes.chat: (context) => const ChatView(),

        // QR desacoplado de QrScanViewModel.
        AppRoutes.qrScan: (context) => const QrScanView(),
        AppRoutes.qrContent: (context) => const QrContentView(),

        AppRoutes.deviceStatus: (context) => const DeviceStatusView(),

        AppRoutes.pickupStep1: (context) => const PickupStep1MapView(),
        AppRoutes.pickupStep2: (context) => const PickupStep2TypeView(),
        AppRoutes.pickupStep3: (context) => const PickupStep3DetailsView(),
        AppRoutes.pickupStep4: (context) => const PickupStep4StoryView(),
        AppRoutes.pickupConfirm: (context) => const PickupConfirmView(),
        AppRoutes.pickupConfirmation: (context) =>
            const PickupConfirmationView(),

        // Recoger dispositivos todavía conserva temporalmente su ViewModel.
        // Lo desacoplamos en una fase posterior para no romper la UI.
        AppRoutes.pickupFlow: (context) => ChangeNotifierProvider(
          create: (_) =>
              PickupFlowViewModel(submitUseCase: SubmitPickupRequestUseCase()),
          child: const PickupFlowPage(),
        ),
      },
    );
  }
}
