import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Existing views/viewmodels (untouched)
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/RegisterUser_viewmodel.dart';

// Core
import 'core/constants/app_routes.dart';
import 'core/database/redime_db.dart';
import 'core/theme/app_theme.dart';

// Device Pickup feature
import 'features/device_pickup/data/datasources/pickup_local_datasource.dart';
import 'features/device_pickup/data/repositories/pickup_repository_impl.dart';
import 'features/device_pickup/domain/usecases/submit_pickup_request.dart';
import 'features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';
import 'features/device_pickup/presentation/views/pickup_flow_page.dart';
import 'features/device_pickup/presentation/views/pickup_confirmation_view.dart';

// Alex Device Pickup / Recycling flow views
import 'features/device_pickup/presentation/views/pickup_step_1_map_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_2_type_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_3_details_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_4_story_view.dart';
import 'features/device_pickup/presentation/views/pickup_confirm_view.dart';

// Welcome feature
import 'views/welcome_view.dart';

// Device Status feature
import 'features/device_status/data/datasources/status_local_datasource.dart';
import 'features/device_status/data/repositories/status_repository_impl.dart';
import 'features/device_status/domain/usecases/get_device_status.dart';
import 'features/device_status/presentation/viewmodels/device_status_viewmodel.dart';
import 'features/device_status/presentation/views/device_status_view.dart';

// QR feature
import 'features/qr/presentation/viewmodels/qr_scan_viewmodel.dart';
import 'views/qr_scan_view.dart';
import 'views/qr_content_view.dart';

// Support feature
import 'views/chat_view.dart';

// Profile feature
import 'features/profile/presentation/views/profile_view.dart';
import 'features/profile/presentation/views/delete_account_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open (and, on first run, create + seed) the local SQLite database before
  // the UI asks for any data. Failing here surfaces the error early.
  try {
    await RedimeDb.instance.ensureReady();
  } catch (e, s) {
    debugPrint('REDIME DB init failed: $e\n$s');
  }

  runApp(
    MultiProvider(
      providers: [
        // ── Existing auth providers (untouched) ──
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterUserViewModel()),

        // ── Device Pickup provider ──
        ChangeNotifierProvider(
          create: (_) {
            final datasource = PickupLocalDataSource();
            final repository = PickupRepositoryImpl(datasource);
            final useCase = SubmitPickupRequestUseCase(repository);
            return PickupFlowViewModel(submitUseCase: useCase);
          },
        ),

        // ── Device Status provider ──
        ChangeNotifierProvider(
          create: (_) {
            final datasource = StatusLocalDataSource();
            final repository = StatusRepositoryImpl(datasource);
            final useCase = GetDeviceStatusUseCase(repository);
            return DeviceStatusViewModel(getStatusUseCase: useCase);
          },
        ),

        // ── QR provider ──
        ChangeNotifierProvider(create: (_) => QrScanViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'REDIME',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.welcome,
      routes: {
        // Welcome
        AppRoutes.welcome: (context) => const WelcomeView(),

        // Existing routes
        AppRoutes.login: (context) => LoginView(),
        AppRoutes.register: (context) => RegisterView(),
        AppRoutes.home: (context) => HomeView(),

        // Device Pickup routes - current flow
        AppRoutes.pickupFlow: (context) => const PickupFlowPage(),
        AppRoutes.pickupConfirmation: (context) =>
            const PickupConfirmationView(),

        // Device Pickup / Recycling flow routes - Alex
        AppRoutes.pickupStep1: (context) => const PickupStep1MapView(),
        AppRoutes.pickupStep2: (context) => const PickupStep2TypeView(),
        AppRoutes.pickupStep3: (context) => const PickupStep3DetailsView(),
        AppRoutes.pickupStep4: (context) => const PickupStep4StoryView(),
        AppRoutes.pickupConfirm: (context) => const PickupConfirmView(),

        // Device Status routes
        AppRoutes.deviceStatus: (context) => const DeviceStatusView(),

        // QR routes
        AppRoutes.qrScan: (context) => const QrScanView(),
        AppRoutes.qrContent: (context) => const QrContentView(),

        // Support routes
        AppRoutes.chat: (context) => const ChatView(),

        // Profile routes
        AppRoutes.profile: (context) => const ProfileView(),
        AppRoutes.deleteAccount: (context) => const DeleteAccountView(),
      },
    );
  }
}
