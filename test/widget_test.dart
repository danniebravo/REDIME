import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:redime/viewmodels/login_viewmodel.dart';
import 'package:redime/viewmodels/RegisterUser_viewmodel.dart';
import 'package:redime/features/device_pickup/data/datasources/pickup_local_datasource.dart';
import 'package:redime/features/device_pickup/data/repositories/pickup_repository_impl.dart';
import 'package:redime/features/device_pickup/domain/usecases/submit_pickup_request.dart';
import 'package:redime/features/device_pickup/presentation/viewmodels/pickup_flow_viewmodel.dart';
import 'package:redime/features/device_status/data/datasources/status_local_datasource.dart';
import 'package:redime/features/device_status/data/repositories/status_repository_impl.dart';
import 'package:redime/features/device_status/domain/usecases/get_device_status.dart';
import 'package:redime/features/device_status/presentation/viewmodels/device_status_viewmodel.dart';
import 'package:redime/main.dart';

void main() {
  testWidgets('App smoke test - login screen renders', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => RegisterUserViewModel()),
          ChangeNotifierProvider(create: (_) {
            final ds = PickupLocalDataSource();
            final repo = PickupRepositoryImpl(ds);
            final uc = SubmitPickupRequestUseCase(repo);
            return PickupFlowViewModel(submitUseCase: uc);
          }),
          ChangeNotifierProvider(create: (_) {
            final ds = StatusLocalDataSource();
            final repo = StatusRepositoryImpl(ds);
            final uc = GetDeviceStatusUseCase(repo);
            return DeviceStatusViewModel(getStatusUseCase: uc);
          }),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // The app should start at the login screen
    expect(find.text('REDIME'), findsWidgets);
  });
}
