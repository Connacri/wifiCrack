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
  String get admin => 'Administrador';

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
  String get adminTooltip => 'Administrador';

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
  String get tabConfig => 'Configuraci?n';

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
  String get messengerDashboard => 'Panel de Sigma Messenger';

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
  String get supportChatPlaceholder => 'Mensaje al soporte...';

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
  String get client => 'Cliente';

  @override
  String get vendor => 'Vendedor';

  @override
  String get deliveryPerson => 'Repartidor';

  @override
  String get wholesaler => 'Mayorista';

  @override
  String get vocalSigma => 'Voz Sigma';

  @override
  String get defaultMessageContent => 'Mensaje';

  @override
  String get myContacts => 'Mis contactos';

  @override
  String get myQrCodeTooltip => 'Mi c?digo QR';

  @override
  String get scanFriendTooltip => 'Escanear a un amigo';

  @override
  String get friendAddedSuccess => '? ?Amigo a?adido con ?xito!';

  @override
  String get editPseudoMenu => 'Editar mi seud?nimo';

  @override
  String get myPseudoTitle => 'Mi seud?nimo';

  @override
  String get enterPseudoHint => 'Introduce tu seud?nimo';

  @override
  String get noContacts => 'Sin contactos';

  @override
  String get scanFriendToStart =>
      'Escanea el c?digo QR de un amigo para empezar';

  @override
  String get scanFriendButton => 'Escanear a un amigo';

  @override
  String get addedOn => 'A?adido el';

  @override
  String get scanQrCodeTitle => 'Escanear un c?digo QR';

  @override
  String get qrCodeUnreadable => 'C?digo QR ilegible, int?ntalo de nuevo.';

  @override
  String get invalidMistralQr => 'Este c?digo QR no es de Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Enlace inv?lido: $error';
  }

  @override
  String get cannotAddSelf => '?? ?No puedes a?adirte a ti mismo!';

  @override
  String get friendAlreadyAdded => '?? Este amigo ya est? en tus contactos.';

  @override
  String get placeQrInFrame => 'Coloca el c?digo QR en el marco';

  @override
  String get retry => 'Reintentar';

  @override
  String get flashlightTooltip => 'Linterna';

  @override
  String get shareLinkTooltip => 'Compartir enlace';

  @override
  String inviteText(String link) {
    return '?A??deme en Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => 'Invitaci?n a Mistral2laude P2P';

  @override
  String get scanMeText =>
      'Escanea este c?digo QR\npara a?adirme como contacto';

  @override
  String get microphonePermissionDenied => 'Permiso de micr?fono denegado';

  @override
  String get connectionNotEstablished =>
      '?? Conexi?n no establecida. Mensaje guardado localmente.';

  @override
  String get noMessagesYet => 'No hay mensajes.\n?Env?a el primero! ??';

  @override
  String get statusConnected => 'Conectado';

  @override
  String get statusConnecting => 'Conectando...';

  @override
  String get statusFailed => 'Fallido';

  @override
  String get statusOffline => 'Sin conexi?n';

  @override
  String get recordingHint => '?? Grabando...';

  @override
  String get messageHint => 'Mensaje...';

  @override
  String get connectingHint => 'Conectando...';

  @override
  String get initFailed => 'Fallo de inicializaci?n';

  @override
  String get defaultUserPseudo => 'Usuario M2C';

  @override
  String get mobileDevice => 'Dispositivo m?vil';

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String get productsTab => 'Productos';

  @override
  String get logisticsTab => 'Logistics';

  @override
  String get ordersTab => 'Pedidos';

  @override
  String get cartTab => 'Carrito';

  @override
  String get toPickUp => 'To Pick Up';

  @override
  String get toPrepare => 'To Prepare';

  @override
  String get toDeliver => 'To Deliver';

  @override
  String get clientModeTooltip => 'Modo cliente';

  @override
  String get adminModeTooltip => 'Modo administrador';

  @override
  String get addProductTooltip => 'A?adir producto';

  @override
  String get orderCreated => 'Pedido creado.';

  @override
  String get orderFailed => 'Pedido fallido.';

  @override
  String get productCreated => 'Producto creado.';

  @override
  String get productUpdated => 'Producto actualizado.';

  @override
  String get productDeleted => 'Producto eliminado.';

  @override
  String get deleteFailed => 'Error al eliminar.';

  @override
  String get deleteProductTitle => 'Eliminar producto';

  @override
  String deleteProductConfirm(String name) {
    return '?Eliminar \"$name\"?';
  }

  @override
  String get imageUploaded => 'Imagen subida.';

  @override
  String imageUploadFailed(String error) {
    return 'Error al subir la imagen: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'El bucket de im?genes de Supabase no est? configurado.';

  @override
  String get searchProductsPlaceholder => 'Buscar productos o SKU';

  @override
  String get inStockFilter => 'En stock';

  @override
  String get includeInactiveFilter => 'Incluir inactivos';

  @override
  String get sortName => 'Nombre';

  @override
  String get sortPriceAsc => 'Precio de menor a mayor';

  @override
  String get sortPriceDesc => 'Precio de mayor a menor';

  @override
  String get sortStockAsc => 'Stock de menor a mayor';

  @override
  String get sortStockDesc => 'Stock de mayor a menor';

  @override
  String get sortPopularity => 'Popularidad';

  @override
  String get gridView => 'Cuadr?cula';

  @override
  String get listView => 'Lista';

  @override
  String get noProductsMatch => 'Ning?n producto coincide con tus filtros.';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get allProductsLoaded => 'Todos los productos cargados.';

  @override
  String get saveProductTitle => 'Guardar producto';

  @override
  String get addProductTitle => 'A?adir producto';

  @override
  String get editProductTitle => 'Editar producto';

  @override
  String get productNameLabel => 'Nombre';

  @override
  String get skuLabel => 'SKU / Referencia';

  @override
  String get priceLabel => 'Precio (DZD)';

  @override
  String get promoPriceLabel => 'Precio promo (DZD)';

  @override
  String get optionalHelper => 'Opcional';

  @override
  String get imageLabel => 'URL de la imagen o ruta de almacenamiento';

  @override
  String get uploadImageButton => 'Subir imagen';

  @override
  String get replaceImageButton => 'Reemplazar imagen';

  @override
  String get uploadingButton => 'Subiendo...';

  @override
  String get stockLabel => 'Existencias';

  @override
  String get popularityLabel => 'Popularidad';

  @override
  String get activeLabel => 'Activo';

  @override
  String get saveButton => 'Guardar';

  @override
  String get savingButton => 'Guardando...';

  @override
  String get unavailableStatus => 'No disponible';

  @override
  String get outOfStockStatus => 'Agotado';

  @override
  String get lowStockStatus => 'Stock bajo';

  @override
  String get inactiveStatus => 'Inactivo';

  @override
  String get promoStatus => 'Promoci?n';

  @override
  String get cartEmpty => 'El carrito est? vac?o.';

  @override
  String get yourCart => 'Tu carrito';

  @override
  String get clearCart => 'Vaciar';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryLabel => 'Entrega';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Tel?fono';

  @override
  String get addressLabel => 'Direcci?n';

  @override
  String get noteLabel => 'Nota';

  @override
  String get checkoutButton => 'Finalizar compra';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count art?culos';
  }

  @override
  String orderNumber(String id) {
    return 'Pedido #$id';
  }

  @override
  String get changeRoleTooltip => 'Cambiar rol (Simulaci?n)';

  @override
  String get orderNotFound => 'Pedido no encontrado';

  @override
  String get globalStatus => 'Estado global';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get paymentLabel => 'Pago';

  @override
  String get productsLabel => 'Productos';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Precio: $price DZD x $quantity';
  }

  @override
  String amountWithCurrency(String amount) {
    return '$amount DZD';
  }

  @override
  String shipmentItemLine(String name, int quantity) {
    return '? $name (x$quantity)';
  }

  @override
  String get noShipmentsYet => 'A?n no hay env?os.';

  @override
  String shipmentsCount(int count) {
    return 'Env?os ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Paquete: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Transportista: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Enviado el';

  @override
  String get itemsInPackage => 'Art?culos en este paquete:';

  @override
  String get confirmOrderButton => 'Confirmar pedido';

  @override
  String get allocateStockButton => 'Asignar stock';

  @override
  String get startPickingButton => 'Iniciar picking';

  @override
  String get packingFinishedButton => 'Empaquetado terminado (Empaquetado)';

  @override
  String get shipButton => 'Etiquetar y enviar';

  @override
  String setInTransitButton(String tracking) {
    return 'Poner en tr?nsito ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Confirmar entrega ($tracking)';
  }

  @override
  String get requestReturnButton => 'Solicitar una devoluci?n';

  @override
  String get newShipmentTitle => 'Nuevo env?o';

  @override
  String get allItemIncludedNote =>
      'Todos los art?culos se incluir?n en este paquete para este ejemplo.';

  @override
  String get trackingNumberLabel => 'N?mero de seguimiento';

  @override
  String get adminStatusTitle => 'Administraci?n : Estado';

  @override
  String get phoneAddressRequired => 'Tel?fono y direcci?n son obligatorios.';

  @override
  String get orderFailedLong => 'Pedido fallido.';

  @override
  String orderCreatedLong(String id) {
    return 'Pedido creado: $id';
  }

  @override
  String get placingOrderButton => 'Realizando pedido...';

  @override
  String get placeOrderButton => 'Realizar pedido';

  @override
  String get loadMoreButton => 'Cargar m?s';

  @override
  String get searchOrderPlaceholder => 'Buscar un pedido...';

  @override
  String get allFilter => 'Todos';

  @override
  String get orderConfirmedStep => 'Confirmado';

  @override
  String get shippedStep => 'Enviado';

  @override
  String get deliveredStep => 'Entregado';

  @override
  String get unknownDate => 'Desconocido';

  @override
  String get p2pMessengerTitle => 'Mensajer?a P2P';

  @override
  String errorWithDetails(String message) {
    return 'Error: $message';
  }

  @override
  String get myQrCode => 'Mi c?digo QR';

  @override
  String get shareQrCodeTitle => 'Comparte tu c?digo QR';

  @override
  String get shareQrCodeSubtitle =>
      'Deja que tus amigos escaneen este c?digo para a?adirse a sus contactos.';

  @override
  String get takeScreenshotToShare =>
      'Haz una captura de pantalla para compartir tu c?digo QR.';

  @override
  String get initErrorTitle => 'Error de inicializaci?n';

  @override
  String get messagesTitle => 'Mensajes';

  @override
  String get addContactTooltip => 'A?adir contacto';

  @override
  String get noConversations => 'A?n no hay conversaciones';

  @override
  String get addContactToStart => 'A?ade un contacto para empezar a chatear';

  @override
  String get typingStatus => 'escribiendo...';

  @override
  String get sayHello => '?Di hola! ??';

  @override
  String get yesterday => 'Ayer';

  @override
  String get addFriendTitle => 'A?adir amigo';

  @override
  String get scanFriendQr => 'Escanea el c?digo QR de tu amigo';

  @override
  String get addContactTitle => 'A?adir contacto';

  @override
  String get yourQrCodeTitle => 'Tu c?digo QR';

  @override
  String get yourQrCodeSubtitle => 'Muestra este c?digo a tu amigo';

  @override
  String get notAvailable => 'N/D';

  @override
  String get deviceIdLabel => 'ID del dispositivo';

  @override
  String get contactAddedSuccess => '?Contacto a?adido con ?xito!';

  @override
  String get dataChannelDisconnected => 'Canal de datos desconectado';

  @override
  String peerNotConnected(String id) {
    return 'Par no conectado: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Error al analizar el mensaje: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'C?digo QR inv?lido: $error';
  }

  @override
  String get missingDeviceId => 'Falta ID del dispositivo';

  @override
  String get missingPseudo => 'Seud?nimo faltante';

  @override
  String get missingPublicKey => 'Clave p?blica faltante';

  @override
  String get cannotAddSelfError => 'No puedes a?adirte a ti mismo';

  @override
  String get invalidPublicKeyFormat => 'Formato de clave p?blica inv?lido';

  @override
  String errorParsingQrCode(String error) {
    return 'Error al analizar el c?digo QR: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Amigo';

  @override
  String get encryptedMessage => '[Mensaje cifrado]';

  @override
  String get youEncryptedMessage => 'T?: [Mensaje cifrado]';

  @override
  String get imageMessage => '??? Imagen';

  @override
  String get fileMessage => '?? Archivo';

  @override
  String get newMessage => 'Nuevo mensaje';

  @override
  String get reply => 'Responder';

  @override
  String get quickReply => 'Respuesta r?pida';

  @override
  String get markAsRead => 'Marcar como le?do';

  @override
  String get isTyping => 'est? escribiendo...';

  @override
  String get typingIndicator => 'Escribiendo...';

  @override
  String get vocalMessage => 'Mensaje de voz';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Permisos';

  @override
  String get trace => 'Traza';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Por favor corrige los errores del formulario.';

  @override
  String get saveFailed => 'Error al guardar.';

  @override
  String get itemsLabel => 'Artículos';

  @override
  String get productInfoSection => 'Informaci?n';

  @override
  String get productImageSection => 'Imagen';

  @override
  String get productStockStatusSection => 'Stock y estado';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get priceRequired => 'El precio es obligatorio';

  @override
  String get invalidPrice => 'Ingrese un precio válido';

  @override
  String get invalidPromoPrice => 'Ingrese un precio promocional válido';

  @override
  String get promoLowerThanPrice => 'La promo debe ser menor que el precio';

  @override
  String get invalidStock => 'Ingrese un stock válido';

  @override
  String get popularityHelper => 'Más alto significa más popular';

  @override
  String get invalidPopularity => 'Ingrese una popularidad válida';

  @override
  String get addToCart => 'Añadir al carrito';

  @override
  String get stockUnknown => 'Stock desconocido';

  @override
  String get startChatPrompt => 'Comience la conversación';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (Tiempo real)';

  @override
  String get clear => 'Borrar';

  @override
  String get warehouseRole => 'Almacén';

  @override
  String get carrierRole => 'Transportista';

  @override
  String get supportRole => 'Soporte';

  @override
  String get orderStatusCreated => 'Creada';

  @override
  String get orderStatusPendingPayment => 'Pago pendiente';

  @override
  String get orderStatusPaid => 'Pagada';

  @override
  String get orderStatusPaymentFailed => 'Pago fallido';

  @override
  String get orderStatusCancelRequested => 'Cancelación solicitada';

  @override
  String get orderStatusCancelled => 'Cancelada';

  @override
  String get orderStatusOrderConfirmed => 'Confirmada';

  @override
  String get orderStatusStockAllocated => 'Stock asignado';

  @override
  String get orderStatusBackorder => 'En espera de stock';

  @override
  String get orderStatusPicking => 'Preparación';

  @override
  String get orderStatusPacked => 'Empaquetada';

  @override
  String get orderStatusReadyToShip => 'Lista para enviar';

  @override
  String get orderStatusPartiallyShipped => 'Parcialmente enviada';

  @override
  String get orderStatusShipped => 'Enviada';

  @override
  String get orderStatusPartiallyDelivered => 'Parcialmente entregada';

  @override
  String get orderStatusDelivered => 'Entregada';

  @override
  String get orderStatusDeliveryFailed => 'Entrega fallida';

  @override
  String get orderStatusException => 'Excepción';

  @override
  String get orderStatusReturnRequested => 'Devolución solicitada';

  @override
  String get orderStatusReturnInTransit => 'Devolución en tránsito';

  @override
  String get orderStatusReturnReceived => 'Devolución recibida';

  @override
  String get orderStatusRefundPending => 'Reembolso pendiente';

  @override
  String get orderStatusRefunded => 'Reembolsada';

  @override
  String get orderStatusClosed => 'Cerrada';

  @override
  String get shipmentStatusLabelCreated => 'Etiqueta creada';

  @override
  String get shipmentStatusPickedUp => 'Recogido';

  @override
  String get shipmentStatusInTransit => 'En tránsito';

  @override
  String get shipmentStatusArrivedAtHub => 'Llegó al centro';

  @override
  String get shipmentStatusCustomsClearance => 'Despacho de aduana';

  @override
  String get shipmentStatusOutForDelivery => 'En reparto';

  @override
  String get shipmentStatusDelivered => 'Entregado';

  @override
  String get shipmentStatusDeliveryFailed => 'Entrega fallida';

  @override
  String get shipmentStatusException => 'Excepción';

  @override
  String get shipmentStatusLost => 'Perdido';

  @override
  String get shipmentStatusDamaged => 'Dañado';

  @override
  String get shipmentStatusReturnToSender => 'Devuelto al remitente';

  @override
  String get returnStatusRequested => 'Solicitado';

  @override
  String get returnStatusAuthorized => 'Autorizado';

  @override
  String get returnStatusLabelIssued => 'Etiqueta emitida';

  @override
  String get returnStatusInTransit => 'En tránsito';

  @override
  String get returnStatusReceived => 'Recibido';

  @override
  String get returnStatusRejected => 'Rechazado';

  @override
  String get returnStatusRefundPending => 'Reembolso pendiente';

  @override
  String get returnStatusRefunded => 'Reembolsado';

  @override
  String get paymentStatusPending => 'Pendiente';

  @override
  String get paymentStatusAuthorized => 'Autorizado';

  @override
  String get paymentStatusCaptured => 'Capturado';

  @override
  String get paymentStatusVoided => 'Anulado';

  @override
  String get paymentStatusRefunded => 'Reembolsado';

  @override
  String get paymentStatusFailed => 'Fallido';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'Más vendido';

  @override
  String get readMore => 'leer más';

  @override
  String get showLess => 'ver menos';
}
