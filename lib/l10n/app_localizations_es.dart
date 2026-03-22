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
  String confirmDeleteConversation(Object pseudo) {
    return '¿Eliminar todos los mensajes con $pseudo?';
  }

  @override
  String get conversationDeleted => 'Conversación eliminada localmente.';

  @override
  String get p2pSecure => 'P2P Seguro';

  @override
  String coinsForUser(Object pseudo) {
    return 'Monedas para $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'Error de escaneo: $error';
  }

  @override
  String get scanNotSupported =>
      'El escaneo WiFi no es compatible con este dispositivo.';

  @override
  String get gpsDisabled => 'El GPS está desactivado.';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
