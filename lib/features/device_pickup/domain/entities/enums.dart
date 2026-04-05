/// Device category types matching the Figma grid
enum DeviceType {
  largeAppliance,
  smallAppliance,
  telecomEquipment,
  other;

  String get displayName {
    switch (this) {
      case DeviceType.largeAppliance:
        return 'Electrodom\u00e9sticos\ngrandes';
      case DeviceType.smallAppliance:
        return 'Electrodom\u00e9sticos\npeque\u00f1os';
      case DeviceType.telecomEquipment:
        return 'Equipos de\ntelecomunicaciones';
      case DeviceType.other:
        return 'Otros';
    }
  }
}

/// How the device will be delivered
enum DeliveryMethod {
  homePickup,
  dropOffPoint;

  String get displayName {
    switch (this) {
      case DeliveryMethod.homePickup:
        return 'Recogida a domicilio';
      case DeliveryMethod.dropOffPoint:
        return 'Punto de entrega';
    }
  }
}

/// What will happen with the device
enum ProcessingType {
  standardRecycle,
  commemoration;

  String get displayName {
    switch (this) {
      case ProcessingType.standardRecycle:
        return 'Reciclaje est\u00e1ndar';
      case ProcessingType.commemoration:
        return 'Conmemoraci\u00f3n';
    }
  }
}

/// Tracking stages for the device status timeline
enum TrackingStage {
  delivery,
  processing,
  completed;

  String get displayName {
    switch (this) {
      case TrackingStage.delivery:
        return 'Entrega';
      case TrackingStage.processing:
        return 'Procesamiento';
      case TrackingStage.completed:
        return 'Finalizado';
    }
  }

  int get order {
    switch (this) {
      case TrackingStage.delivery:
        return 0;
      case TrackingStage.processing:
        return 1;
      case TrackingStage.completed:
        return 2;
    }
  }
}

/// Device working condition
enum DeviceCondition {
  fullyWorking,
  partiallyWorking,
  notWorking;

  String get displayName {
    switch (this) {
      case DeviceCondition.fullyWorking:
        return 'S\u00ed';
      case DeviceCondition.partiallyWorking:
        return 'S\u00ed, pero no en su totalidad';
      case DeviceCondition.notWorking:
        return 'No';
    }
  }
}

/// Physical integrity of the device
enum DeviceIntegrity {
  singlePiece,
  looseParts;

  String get displayName {
    switch (this) {
      case DeviceIntegrity.singlePiece:
        return 'S\u00ed';
      case DeviceIntegrity.looseParts:
        return 'No, tiene piezas sueltas';
    }
  }
}
