class AppStrings {
  AppStrings._();

  // General
  static const String appName = 'REDIME';
  static const String continueButton = 'Continuar';
  static const String back = 'Volver';

  // Step 1 - Device Type
  static const String step1Label = 'Paso 1';
  static const String step1Title = 'Empecemos\ncon la redenci\u00f3n';
  static const String step1Subtitle =
      '\u00bfSelecciona qu\u00e9 tipo de dispositivo deseas\nreciclar hoy?';
  static const String largeAppliances = 'Electrodom\u00e9sticos\ngrandes';
  static const String smallAppliances = 'Electrodom\u00e9sticos\npeque\u00f1os';
  static const String telecomEquipment = 'Equipos de\ntelecomunicaciones';
  static const String otherDevices = 'Otros';

  // Step 2 - Device Details
  static const String step2Label = 'Paso 2';
  static const String step2Title = 'Detalles del Equipo';
  static const String step2Subtitle =
      'Completa la informaci\u00f3n t\u00e9cnica para su\ntratamiento.';
  static const String electronicTypeLabel = '\u00bfQu\u00e9 tipo de electr\u00f3nico es?';
  static const String electronicTypeHint = 'Ej: Licuadora, Router, Laptop...';
  static const String brandLabel = 'Marca del dispositivo';
  static const String brandHint = 'Ej: Sony, Samsung, DELL...';
  static const String weightLabel = 'Peso estimado';
  static const String ageLabel = 'Antig\u00fcedad';
  static const String selectPlaceholder = 'Selecciona';
  static const String stillWorksLabel = '\u00bfA\u00fan funciona?';
  static const String worksYes = 'S\u00ed';
  static const String worksPartial = 'S\u00ed, pero no en su totalidad';
  static const String worksNo = 'No';
  static const String onePieceLabel = '\u00bfEst\u00e1 en una sola pieza?';
  static const String onePieceYes = 'S\u00ed';
  static const String onePieceNo = 'No, tiene piezas sueltas';

  // Step 3 - Address & Date
  static const String step3Label = 'Paso 3';
  static const String step3Title = '\u00bfA d\u00f3nde vamos?';
  static const String step3Subtitle = '\u00bfD\u00f3nde y cu\u00e1ndo pasamos por \u00e9l?';
  static const String addressLabel = 'Direcci\u00f3n';
  static const String addressHint = 'Calle 10 # 45 - 20...';
  static const String dateLabel = 'Fecha';
  static const String dateHint = 'dd/mm/aa';

  // Step 4 - Story
  static const String step4Label = 'Paso 4';
  static const String step4Title = 'Su Historia';
  static const String step4Question = '\u00bfQu\u00e9 significa este objeto para ti?';
  static const String step4Description =
      'Este paso es totalmente opcional; si no quieres que tu '
      'dispositivo aparezca como exhibici\u00f3n en el museo de '
      'memorias de REDIME, solo salta este paso.';
  static const String storyHint = 'Este fue mi primer celular...';
  static const String storyLabel = 'Escribe un recuerdo o mensaje';
  static const String uploadPhotoTitle = 'Subir foto del recuerdo';
  static const String uploadPhotoSubtitle =
      '(Esta imagen ser\u00e1 colocada a la par de tu\n'
      'dispositivo en el museo, contando su historia.)';
  static const String skipButton = 'Omitir...';
  static const String sendStoryButton = 'Enviar historia';

  // Confirmation
  static const String confirmationAppBarTitle = '\u00a1Gracias!';
  static const String confirmationTitle = '\u00a1Rescate iniciado!';
  static const String confirmationSubtitle =
      'Gracias por confiar en Redime para dar\nuna segunda vida a tu dispositivo.';
  static const String backToHome = 'Volver al inicio';
  static const String shareOnSocial = 'Compartir en redes';

  // Device Status
  static const String deviceStatusTitle = 'Estado del dispositivo';
  static const String trackingDeliveryPickup = 'Yendo a recogerlo';
  static const String trackingDeliveryDropOff = 'Depositado';
  static const String trackingProcessingRecycle = 'A punto de darle una nueva vida';
  static const String trackingProcessingCommemoration = 'Extrayendo memorias';
  static const String trackingCompletedRecycle = 'Ahora es parte de algo mejor';
  static const String trackingCompletedCommemoration = 'Ahora es una memoria viviente';

  // Weight options
  static const List<String> weightOptions = [
    'Menos de 1 kg',
    '1 - 5 kg',
    '5 - 15 kg',
    '15 - 30 kg',
    'M\u00e1s de 30 kg',
  ];

  // Age options
  static const List<String> ageOptions = [
    'Menos de 1 a\u00f1o',
    '1 - 3 a\u00f1os',
    '3 - 5 a\u00f1os',
    '5 - 10 a\u00f1os',
    'M\u00e1s de 10 a\u00f1os',
  ];
}
