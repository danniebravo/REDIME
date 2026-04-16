import 'package:flutter/material.dart';
import '../../features/device_pickup/presentation/views/pickup_step_1_map_view.dart';
import '../../features/device_pickup/presentation/views/pickup_step_2_type_view.dart';
import '../../features/device_pickup/presentation/views/pickup_step_3_details_view.dart';
import '../../features/device_pickup/presentation/views/pickup_step_4_story_view.dart';
import '../../features/device_pickup/presentation/views/pickup_confirm_view.dart';

class AppRoutes {
  static const String pickupStep1 = '/';
  static const String pickupStep2 = '/pickup_step_2';
  static const String pickupStep3 = '/pickup_step_3';
  static const String pickupStep4 = '/pickup_step_4';
  static const String pickupConfirm = '/pickup_confirm';

  static Map<String, WidgetBuilder> get routes => {
        pickupStep1: (context) => const PickupStep1MapView(),
        pickupStep2: (context) => const PickupStep2TypeView(),
        pickupStep3: (context) => const PickupStep3DetailsView(),
        pickupStep4: (context) => const PickupStep4StoryView(),
        pickupConfirm: (context) => const PickupConfirmView(),
      };
}
