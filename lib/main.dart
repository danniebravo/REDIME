import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'features/device_pickup/domain/usecases/submit_pickup_request.dart';
import 'features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';
import 'features/device_pickup/presentation/views/pickup_confirm_view.dart';
import 'features/device_pickup/presentation/views/pickup_confirmation_view.dart';
import 'features/device_pickup/presentation/views/pickup_flow_page.dart';
import 'features/device_pickup/presentation/views/pickup_step_1_map_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_2_type_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_3_details_view.dart';
import 'features/device_pickup/presentation/views/pickup_step_4_story_view.dart';
import 'features/device_pickup/presentation/views/pickup_story_thanks_view.dart';

import 'features/qr/presentation/viewmodels/qr_scan_viewmodel.dart';

import 'viewmodels/RegisterUser_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/pickup_list_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';

import 'models/pickup_model.dart';

import 'views/change_password_view.dart';
import 'views/chat_view.dart';
import 'views/delete_account_view.dart';
import 'views/device_status_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/pickup_status_detail_view.dart';
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
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PickupListViewModel()),
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
      initialRoute: AppRoutes.welcome,
      debugShowCheckedModeBanner: false,
      title: 'APP REDIME',
      theme: AppTheme.lightTheme,
      routes: {
        AppRoutes.welcome: (context) => const WelcomeView(),
        AppRoutes.register: (context) => RegisterView(),
        AppRoutes.login: (context) => LoginView(),
        AppRoutes.home: (context) => const HomeView(),
        AppRoutes.profile: (context) => ChangeNotifierProvider(
          create: (_) => ProfileViewModel()..loadProfile(),
          child: const ProfileView(),
        ),
        AppRoutes.deleteAccount: (context) => const DeleteAccountView(),
        AppRoutes.changePassword: (context) => const ChangePasswordView(),
        AppRoutes.chat: (context) => const ChatView(),

        AppRoutes.qrScan: (context) => ChangeNotifierProvider(
          create: (_) => QrScanViewModel(),
          child: const QrScanView(),
        ),
        AppRoutes.qrContent: (context) => const QrContentView(),

        AppRoutes.deviceStatus: (context) => const DeviceStatusView(),
        AppRoutes.pickupStatusDetail: (context) {
          final pickup =
              ModalRoute.of(context)!.settings.arguments as PickupModel;
          return PickupStatusDetailView(pickup: pickup);
        },

        AppRoutes.pickupStep1: (context) => const PickupStep1MapView(),
        AppRoutes.pickupStep2: (context) => const PickupStep2TypeView(),
        AppRoutes.pickupStep3: (context) => const PickupStep3DetailsView(),
        AppRoutes.pickupStep4: (context) => const PickupStep4StoryView(),
        AppRoutes.pickupConfirm: (context) => const PickupConfirmView(),
        AppRoutes.pickupConfirmation: (context) =>
            const PickupConfirmationView(),
        AppRoutes.pickupStoryThanks: (context) =>
            const PickupStoryThanksView(),

        AppRoutes.pickupFlow: (context) => ChangeNotifierProvider(
          create: (_) =>
              PickupFlowViewModel(submitUseCase: SubmitPickupRequestUseCase()),
          child: const PickupFlowPage(),
        ),
      },
    );
  }
}
