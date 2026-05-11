class AppRoutes {
  AppRoutes._();

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  // Device Pickup - flujo actual
  static const String pickupFlow = '/pickup-flow';
  static const String pickupConfirmation = '/pickup-confirmation';

  // Device Pickup / Recycling flow - pantallas de Alex
  static const String pickupStep1 = '/pickup-step-1';
  static const String pickupStep2 = '/pickup-step-2';
  static const String pickupStep3 = '/pickup-step-3';
  static const String pickupStep4 = '/pickup-step-4';
  static const String pickupConfirm = '/pickup-confirm';

  // Device Status
  static const String deviceStatus = '/device-status';

  // QR
  static const String qrScan = '/qr-scan';
  static const String qrContent = '/qr-content';

  // Support
  static const String chat = '/chat';

  // Profile
  static const String profile = '/profile';
  static const String deleteAccount = '/delete-account';
}
