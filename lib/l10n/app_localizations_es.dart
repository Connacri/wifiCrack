// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Inicio';

  @override
  String get map => 'Mapa';

  @override
  String get scan => 'Escanear';

  @override
  String get settings => 'Ajustes';

  @override
  String get admin => 'Admin';

  @override
  String get commerce => 'Comercio';

  @override
  String get p2pChat => 'Chat P2P';

  @override
  String get publishAd => 'Publicar anuncio';

  @override
  String get connect => 'Conexión';

  @override
  String get disconnect => 'Desconexión';

  @override
  String get copy => 'Copiar';

  @override
  String get share => 'Compartir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get search => 'Buscar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get password => 'Contraseña';

  @override
  String get pseudo => 'Seudónimo';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get profileTooltip => 'Perfil';

  @override
  String get adminTooltip => 'Admin';

  @override
  String get chatTooltip => 'Chat';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'Escanear WiFi';

  @override
  String get scanning => 'Escaneando...';

  @override
  String get noNetworks => 'No se encontraron redes';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get fixPermissions => 'Corregir permisos';

  @override
  String get detected => 'Detectado';

  @override
  String get connected => 'Conectado';

  @override
  String get failed => 'Fallido';

  @override
  String get coins => 'Monedas';

  @override
  String get publishAdEarn => 'Publicar anuncio y ganar';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Desconectado del admin.';

  @override
  String get logoutTooltip => 'Cierre de sesión local';

  @override
  String get tabStats => 'Estadísticas';

  @override
  String get tabAds => 'Anuncios';

  @override
  String get tabTargets => 'Objetivos';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabTraces => 'Rastros';

  @override
  String get tabContacts => 'Contactos';

  @override
  String get tabConfig => 'Config';

  @override
  String get securityAdmin => '🔐 Seguridad Admin';

  @override
  String get changePasswordInfo =>
      'Cambie la contraseña de acceso al panel. Este cambio es inmediato para todos los dispositivos.';

  @override
  String get minPasswordError =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get passwordUpdateSuccess =>
      '✅ ¡Contraseña de administrador actualizada en Supabase!';

  @override
  String get passwordUpdateError => '❌ Error durante la actualización.';

  @override
  String get addCarousel => '📢 Añadir al Carrusel';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get publish => 'Publicar';

  @override
  String get bannerAdded => '¡Banner añadido!';

  @override
  String get userSubmissionsManagement => 'Gestión de envíos de usuarios';

  @override
  String get unknown => 'Desconocido';

  @override
  String get model => 'Modelo';

  @override
  String get coinsLabel => 'Monedas';

  @override
  String get chat => 'Chat';

  @override
  String get giveCoins => 'Dar monedas';

  @override
  String get coinsAmountLabel => 'Número de monedas';

  @override
  String get add => 'Añadir';

  @override
  String get online => 'En línea';

  @override
  String get offline => 'Fuera de línea';

  @override
  String get searchPlaceholder => 'Buscar...';

  @override
  String get bannerText => 'Texto del banner';

  @override
  String get imageUrl => 'URL de la imagen';

  @override
  String get externalLink => 'Enlace externo';

  @override
  String get editPseudo => 'Editar mi seudónimo';

  @override
  String get newPseudo => 'Nuevo seudónimo';

  @override
  String get pseudoUpdated => '¡Seudónimo actualizado!';

  @override
  String get pseudoError => 'Seudónimo no disponible o error.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'No se encontraron usuarios.';

  @override
  String get noActivityAvailable => 'No hay actividad disponible.';

  @override
  String get deleteConversation => 'Borrar conversación';

  @override
  String confirmDeleteConversation(String pseudo) {
    return '¿Eliminar todos los mensajes con $pseudo?';
  }

  @override
  String get conversationDeleted => 'Conversación eliminada localmente.';

  @override
  String get p2pSecure => 'P2P Seguro';

  @override
  String coinsForUser(String pseudo) {
    return 'Monedas para $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$amount monedas añadidas a $pseudo';
  }

  @override
  String get amountLabel => 'Cantidad';

  @override
  String get addCoins => 'Añadir monedas';

  @override
  String get refreshUsers => 'Refrescar usuarios';

  @override
  String get changePseudoTooltip => 'Cambiar mi seudónimo';

  @override
  String get userProfile => 'Perfil';

  @override
  String p2pSecureSubtitle(String id) {
    return 'P2P Seguro • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Borrar conversación';

  @override
  String get addCoinsTooltip => 'Dar monedas';

  @override
  String get coinsToAddLabel => 'Número de monedas a añadir';

  @override
  String get messageSigmaPlaceholder => 'Mensaje Sigma...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'Perfil de usuario';

  @override
  String get tabInfo => 'Información';

  @override
  String get tabActivity => 'Actividad';

  @override
  String get tabSecurity => 'Seguridad';

  @override
  String get tabNetwork => 'Red';

  @override
  String get identity => 'Identidad';

  @override
  String get deviceAndSession => 'Dispositivo y Sesión';

  @override
  String get lastActivity => 'Última actividad';

  @override
  String get createdAt => 'Creado el';

  @override
  String get activitySummary => 'Resumen de actividad';

  @override
  String get eventsCollected => 'Eventos recopilados';

  @override
  String get validGpsPoints => 'Puntos GPS válidos';

  @override
  String get maxContactsSeen => 'Contactos máximos vistos';

  @override
  String get securityStatus => 'Estado de seguridad';

  @override
  String get activeSession => 'Sesión activa';

  @override
  String get lastPing => 'Último ping';

  @override
  String agoMin(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String get anomalyDetected => 'Anomalía detectada';

  @override
  String get none => 'Ninguna (heurística local)';

  @override
  String get securityNote =>
      'Nota: esta pestaña muestra señales de seguridad de la aplicación basadas en los datos disponibles (no es una auditoría completa del servidor).';

  @override
  String get networkStatus => 'Estado de la red';

  @override
  String get mainChannel => 'Canal principal';

  @override
  String get presence => 'Presencia';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'No disponible';

  @override
  String get geolocSamples => 'Muestras de geolocalización';

  @override
  String get rawDebugData => 'Datos brutos (depuración)';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get sigmaAdProposalTitle => '🚀 Propón tu anuncio Sigma';

  @override
  String get submitAdSuccess =>
      '✅ ¡Envío realizado! Espera la validación del administrador para tus monedas.';

  @override
  String get submitAdInfo =>
      '¡Envía una imagen, una descripción y gana monedas!';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get submit => 'Enviar';

  @override
  String get bonusActivated => '¡Bono de monedas activado! (Vídeo visto)';

  @override
  String get watchVideoBonus => 'Ver un vídeo para +50 monedas de bono';

  @override
  String get languageSelectorTitle => 'Select Language / Seleccionar idioma';

  @override
  String get imageLinkUrl => 'Enlace de la imagen (URL)';

  @override
  String get bonusAddedText => '¡Bono de monedas activado! (Vídeo visto)';

  @override
  String get close => 'Cerrar';

  @override
  String copiedToClipboard(String text) {
    return 'Clave copiada: $text';
  }

  @override
  String get disconnectTooltip => 'Desconectar';

  @override
  String get connectTooltip => 'Calcular y Conectar';

  @override
  String get audioUnavailable => 'Vocal no disponible.';

  @override
  String get supportSigmaPro => 'Soporte Sigma Pro';

  @override
  String get p2pEncryptedChat => 'Mensajería P2P cifrada';

  @override
  String get needHelpMessage => '¿Necesita ayuda? Envíenos un mensaje.';

  @override
  String get chooseAdminRole => 'Elija su rol de Admin';

  @override
  String get configRequiredTitle => 'Configuración requerida';

  @override
  String get configRequiredInfo => 'Para funcionar, Sigma necesita: \n';

  @override
  String get configVisibleNote =>
      'Sin esto, no será visible en el mapa de Sigma.';

  @override
  String get configureNow => 'Configurar ahora';

  @override
  String get accessDenied => 'Acceso denegado.';

  @override
  String sigmaKey(String key) {
    return 'Clave Sigma: $key';
  }

  @override
  String get wifiDisabled => 'El WiFi está desactivado.';

  @override
  String get locationWifiPermsRequired =>
      'Se requieren permisos de ubicación/WiFi.';

  @override
  String get gpsRequiredAndroid => 'Se requiere GPS para escanear en Android.';

  @override
  String get noCompatibleNetworks =>
      'No se detectaron redes compatibles cerca.';

  @override
  String scanError(String error) {
    return 'Error de escaneo: $error';
  }

  @override
  String get scanNotSupported =>
      'El escaneo WiFi no es compatible con este dispositivo.';

  @override
  String get gpsDisabled => 'El GPS está desactivado.';

  @override
  String scanUnavailable(String status) {
    return 'El escaneo no está disponible ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Por favor, introduzca la clave manualmente si falla la conexión.';

  @override
  String get authRequired => 'Autenticación requerida';

  @override
  String get chooseRole => 'Elija su rol';

  @override
  String get user => 'Usuario';

  @override
  String get validate => 'Validar';

  @override
  String get authTitle => 'Autenticación';

  @override
  String get commerceLogin => 'Inicio de sesión de comercio';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get forgotPassword => '¿Olvidó su contraseña?';

  @override
  String get loginGoogle => 'Continuar con Google';

  @override
  String get noAccount => '¿No tiene cuenta? Regístrese';

  @override
  String get hasAccount => '¿Ya tiene cuenta? Inicie sesión';

  @override
  String get resetEmailSent => '¡Correo de restablecimiento enviado!';

  @override
  String get fillAllFields => 'Por favor, rellene todos los campos.';

  @override
  String googleError(String error) {
    return 'Error de Google: $error';
  }

  @override
  String get permsRequiredTitle => 'Permisos requeridos';

  @override
  String get permsRequiredInfo =>
      'Para usar esta aplicación, debe imperativamente:\n\n';

  @override
  String get permsFatalNote => 'Sin esto, la aplicación no puede funcionar.';

  @override
  String get understandAndConfigure => 'Lo he entendido, configurar';

  @override
  String get commerceDisconnectConfirm => '¿Quiere desconectarse del comercio?';

  @override
  String get startDiscussion => 'Comenzar la discusión';

  @override
  String get yourMessage => 'Su mensaje...';

  @override
  String get orderErrorUnidentified =>
      'Imposible realizar el pedido: usuario no identificado.';

  @override
  String get client => 'Client';

  @override
  String get vendor => 'Vendor';

  @override
  String get deliveryPerson => 'Delivery Person';

  @override
  String get wholesaler => 'Wholesaler';

  @override
  String get vocalSigma => 'Sigma Voice';

  @override
  String get defaultMessageContent => 'Message';

  @override
  String get myContacts => 'My Contacts';

  @override
  String get myQrCodeTooltip => 'My QR Code';

  @override
  String get scanFriendTooltip => 'Scan a friend';

  @override
  String get friendAddedSuccess => '✅ Friend added successfully!';

  @override
  String get editPseudoMenu => 'Edit my pseudo';

  @override
  String get myPseudoTitle => 'My pseudo';

  @override
  String get enterPseudoHint => 'Enter your pseudo';

  @override
  String get noContacts => 'No contacts';

  @override
  String get scanFriendToStart => 'Scan a friend\'s QR Code to start';

  @override
  String get scanFriendButton => 'Scan a friend';

  @override
  String get addedOn => 'Added on';

  @override
  String get scanQrCodeTitle => 'Scan a QR Code';

  @override
  String get qrCodeUnreadable => 'QR Code unreadable, try again.';

  @override
  String get invalidMistralQr => 'This QR Code is not from Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Invalid link: $error';
  }

  @override
  String get cannotAddSelf => '🚫 You cannot add yourself!';

  @override
  String get friendAlreadyAdded =>
      'ℹ️ This friend is already in your contacts.';

  @override
  String get placeQrInFrame => 'Place the QR Code in the frame';

  @override
  String get retry => 'Retry';

  @override
  String get flashlightTooltip => 'Flashlight';

  @override
  String get shareLinkTooltip => 'Share link';

  @override
  String inviteText(String link) {
    return 'Add me on Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => 'Mistral2laude P2P Invitation';

  @override
  String get scanMeText => 'Scan this QR Code\nto add me as a contact';

  @override
  String get microphonePermissionDenied => 'Microphone permission denied';

  @override
  String get connectionNotEstablished =>
      '⚠️ Connection not established. Message saved locally.';

  @override
  String get noMessagesYet => 'No messages.\nSend the first one! 👋';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusConnecting => 'Connecting...';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusOffline => 'Offline';

  @override
  String get recordingHint => '🔴 Recording...';

  @override
  String get messageHint => 'Message...';

  @override
  String get connectingHint => 'Connecting...';

  @override
  String get initFailed => 'Initialization failed';

  @override
  String get defaultUserPseudo => 'M2C User';

  @override
  String get mobileDevice => 'Mobile Device';

  @override
  String get unknownDevice => 'Unknown Device';

  @override
  String get productsTab => 'Products';

  @override
  String get ordersTab => 'Orders';

  @override
  String get cartTab => 'Cart';

  @override
  String get clientModeTooltip => 'Client mode';

  @override
  String get adminModeTooltip => 'Admin mode';

  @override
  String get addProductTooltip => 'Add product';

  @override
  String get orderCreated => 'Order created.';

  @override
  String get orderFailed => 'Order failed.';

  @override
  String get productCreated => 'Product created.';

  @override
  String get productUpdated => 'Product updated.';

  @override
  String get productDeleted => 'Product deleted.';

  @override
  String get deleteFailed => 'Delete failed.';

  @override
  String get deleteProductTitle => 'Delete product';

  @override
  String deleteProductConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get imageUploaded => 'Image uploaded.';

  @override
  String imageUploadFailed(String error) {
    return 'Image upload failed: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Supabase image bucket is not configured.';

  @override
  String get searchProductsPlaceholder => 'Search products or SKU';

  @override
  String get inStockFilter => 'In stock';

  @override
  String get includeInactiveFilter => 'Include inactive';

  @override
  String get sortName => 'Name';

  @override
  String get sortPriceAsc => 'Price low-high';

  @override
  String get sortPriceDesc => 'Price high-low';

  @override
  String get sortStockAsc => 'Stock low-high';

  @override
  String get sortStockDesc => 'Stock high-low';

  @override
  String get sortPopularity => 'Popularity';

  @override
  String get gridView => 'Grid';

  @override
  String get listView => 'List';

  @override
  String get noProductsMatch => 'No products match your filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get allProductsLoaded => 'All products loaded.';

  @override
  String get saveProductTitle => 'Save Product';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get editProductTitle => 'Edit Product';

  @override
  String get productNameLabel => 'Name';

  @override
  String get skuLabel => 'SKU / Reference';

  @override
  String get priceLabel => 'Price (DZD)';

  @override
  String get promoPriceLabel => 'Promo price (DZD)';

  @override
  String get optionalHelper => 'Optional';

  @override
  String get imageLabel => 'Image URL or Storage path';

  @override
  String get uploadImageButton => 'Upload image';

  @override
  String get replaceImageButton => 'Replace image';

  @override
  String get uploadingButton => 'Uploading...';

  @override
  String get stockLabel => 'Stock';

  @override
  String get popularityLabel => 'Popularity';

  @override
  String get activeLabel => 'Active';

  @override
  String get saveButton => 'Save';

  @override
  String get savingButton => 'Saving...';

  @override
  String get unavailableStatus => 'Unavailable';

  @override
  String get outOfStockStatus => 'Out of stock';

  @override
  String get lowStockStatus => 'Low stock';

  @override
  String get inactiveStatus => 'Inactive';

  @override
  String get promoStatus => 'Promo';

  @override
  String get cartEmpty => 'Cart is empty.';

  @override
  String get yourCart => 'Your cart';

  @override
  String get clearCart => 'Clear';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get addressLabel => 'Address';

  @override
  String get noteLabel => 'Note';

  @override
  String get checkoutButton => 'Checkout';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String orderNumber(String id) {
    return 'Order #$id';
  }

  @override
  String get changeRoleTooltip => 'Change role (Simulation)';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get globalStatus => 'Global status';

  @override
  String get dateLabel => 'Date';

  @override
  String get customerLabel => 'Customer';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get productsLabel => 'Products';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Price: $price DZD x $quantity';
  }

  @override
  String get noShipmentsYet => 'No shipments yet.';

  @override
  String shipmentsCount(int count) {
    return 'Shipments ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Package: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Carrier: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Shipped on';

  @override
  String get itemsInPackage => 'Items in this package:';

  @override
  String get confirmOrderButton => 'Confirm order';

  @override
  String get allocateStockButton => 'Allocate stock';

  @override
  String get startPickingButton => 'Start Picking';

  @override
  String get packingFinishedButton => 'Packing finished (Packed)';

  @override
  String get shipButton => 'Label & Ship';

  @override
  String setInTransitButton(String tracking) {
    return 'Set In Transit ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Confirm Delivery ($tracking)';
  }

  @override
  String get requestReturnButton => 'Request a return';

  @override
  String get newShipmentTitle => 'New Shipment';

  @override
  String get allItemIncludedNote =>
      'All items will be included in this package for this example.';

  @override
  String get trackingNumberLabel => 'Tracking Number';

  @override
  String get adminStatusTitle => 'Administration : Status';

  @override
  String get phoneAddressRequired => 'Phone and address are required.';

  @override
  String get orderFailedLong => 'Order failed.';

  @override
  String orderCreatedLong(String id) {
    return 'Order created: $id';
  }

  @override
  String get placingOrderButton => 'Placing order...';

  @override
  String get placeOrderButton => 'Place order';

  @override
  String get loadMoreButton => 'Load more';

  @override
  String get searchOrderPlaceholder => 'Search an order...';

  @override
  String get allFilter => 'All';

  @override
  String get orderConfirmedStep => 'Confirmed';

  @override
  String get shippedStep => 'Shipped';

  @override
  String get deliveredStep => 'Delivered';

  @override
  String get unknownDate => 'Unknown';

  @override
  String get p2pMessengerTitle => 'P2P Messenger';

  @override
  String errorWithDetails(String message) {
    return 'Error: $message';
  }

  @override
  String get myQrCode => 'My QR Code';

  @override
  String get shareQrCodeTitle => 'Share your QR Code';

  @override
  String get shareQrCodeSubtitle =>
      'Let your friends scan this code to add you to their contacts.';

  @override
  String get takeScreenshotToShare =>
      'Take a screenshot to share your QR Code.';

  @override
  String get initErrorTitle => 'Initialization Error';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get addContactTooltip => 'Add Contact';

  @override
  String get noConversations => 'No conversations yet';

  @override
  String get addContactToStart => 'Add a contact to start chatting';

  @override
  String get typingStatus => 'typing...';

  @override
  String get sayHello => 'Say hello! 👋';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get addFriendTitle => 'Add Friend';

  @override
  String get scanFriendQr => 'Scan your friend\'s QR Code';

  @override
  String get addContactTitle => 'Add Contact';

  @override
  String get yourQrCodeTitle => 'Your QR Code';

  @override
  String get yourQrCodeSubtitle => 'Show this code to your friend';

  @override
  String get notAvailable => 'N/A';

  @override
  String get deviceIdLabel => 'Device ID';

  @override
  String get contactAddedSuccess => 'Contact added successfully!';

  @override
  String get dataChannelDisconnected => 'Data channel disconnected';

  @override
  String peerNotConnected(String id) {
    return 'Peer not connected: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Error parsing message: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'Invalid QR Code: $error';
  }

  @override
  String get missingDeviceId => 'Missing Device ID';

  @override
  String get missingPseudo => 'Missing Pseudo';

  @override
  String get missingPublicKey => 'Missing Public Key';

  @override
  String get cannotAddSelfError => 'Cannot add yourself';

  @override
  String get invalidPublicKeyFormat => 'Invalid public key format';

  @override
  String errorParsingQrCode(String error) {
    return 'Error parsing QR Code: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Friend';

  @override
  String get encryptedMessage => '[Encrypted message]';

  @override
  String get youEncryptedMessage => 'You: [Encrypted message]';

  @override
  String get imageMessage => '🖼️ Image';

  @override
  String get fileMessage => '📎 File';

  @override
  String get newMessage => 'New message';

  @override
  String get reply => 'Reply';

  @override
  String get quickReply => 'Quick reply';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get isTyping => 'is typing...';

  @override
  String get typingIndicator => 'Typing...';

  @override
  String get vocalMessage => 'Vocal message';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Permissions';

  @override
  String get trace => 'Trace';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Please fix the form errors.';

  @override
  String get saveFailed => 'Save failed.';

  @override
  String get itemsLabel => 'Items';
}
