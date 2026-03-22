// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Главная';

  @override
  String get map => 'Карта';

  @override
  String get scan => 'Сканировать';

  @override
  String get settings => 'Настройки';

  @override
  String get admin => 'Админ';

  @override
  String get commerce => 'Коммерция';

  @override
  String get p2pChat => 'P2P-чат';

  @override
  String get publishAd => 'Опубликовать объявление';

  @override
  String get connect => 'Подключиться';

  @override
  String get disconnect => 'Отключиться';

  @override
  String get copy => 'Копировать';

  @override
  String get share => 'Поделиться';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get save => 'Сохранить';

  @override
  String get search => 'Поиск';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успех';

  @override
  String get password => 'Пароль';

  @override
  String get pseudo => 'Псевдоним';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get profileTooltip => 'Профиль';

  @override
  String get adminTooltip => 'Админ';

  @override
  String get chatTooltip => 'Чат';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'Сканировать WiFi';

  @override
  String get scanning => 'Анализ...';

  @override
  String get noNetworks => 'Сети не найдены';

  @override
  String get permissionDenied => 'Доступ запрещен';

  @override
  String get fixPermissions => 'Исправить разрешения';

  @override
  String get detected => 'Обнаружено';

  @override
  String get connected => 'Подключено';

  @override
  String get failed => 'Ошибка';

  @override
  String get coins => 'Монеты';

  @override
  String get publishAdEarn => 'Опубликуйте объявление и заработайте';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Отключено от админки.';

  @override
  String get logoutTooltip => 'Локальный выход';

  @override
  String get tabStats => 'Статистика';

  @override
  String get tabAds => 'Объявления';

  @override
  String get tabTargets => 'Цели';

  @override
  String get tabMap => 'Карта';

  @override
  String get tabTraces => 'Следы';

  @override
  String get tabContacts => 'Контакты';

  @override
  String get tabConfig => 'Конфиг';

  @override
  String get securityAdmin => '🔐 Безопасность админа';

  @override
  String get changePasswordInfo =>
      'Измените пароль доступа к панели управления. Это изменение вступит в силу немедленно для всех устройств.';

  @override
  String get minPasswordError => 'Пароль должен содержать не менее 6 символов.';

  @override
  String get passwordUpdateSuccess => '✅ Пароль админа обновлен в Supabase!';

  @override
  String get passwordUpdateError => '❌ Ошибка при обновлении.';

  @override
  String get addCarousel => '📢 Добавить в карусель';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get publish => 'Опубликовать';

  @override
  String get bannerAdded => 'Баннер добавлен!';

  @override
  String get userSubmissionsManagement => 'Управление заявками пользователей';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get model => 'Модель';

  @override
  String get coinsLabel => 'Монеты';

  @override
  String get chat => 'Чат';

  @override
  String get giveCoins => 'Дать монеты';

  @override
  String get coinsAmountLabel => 'Количество монет';

  @override
  String get add => 'Добавить';

  @override
  String get online => 'В сети';

  @override
  String get offline => 'Не в сети';

  @override
  String get searchPlaceholder => 'Поиск...';

  @override
  String get bannerText => 'Текст баннера';

  @override
  String get imageUrl => 'URL изображения';

  @override
  String get externalLink => 'Внешняя ссылка';

  @override
  String get editPseudo => 'Изменить мой псевдоним';

  @override
  String get newPseudo => 'Новый псевдоним';

  @override
  String get pseudoUpdated => 'Псевдоним обновлен!';

  @override
  String get pseudoError => 'Псевдоним недоступен или ошибка.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'Пользователи не найдены.';

  @override
  String get noActivityAvailable => 'Нет доступных действий.';

  @override
  String get deleteConversation => 'Очистить беседу';

  @override
  String confirmDeleteConversation(String pseudo) {
    return 'Удалить все сообщения с $pseudo?';
  }

  @override
  String get conversationDeleted => 'Беседа удалена локально.';

  @override
  String get p2pSecure => 'Безопасный P2P';

  @override
  String coinsForUser(String pseudo) {
    return 'Монеты для $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$amount монет добавлено пользователю $pseudo';
  }

  @override
  String get amountLabel => 'Сумма';

  @override
  String get addCoins => 'Добавить монеты';

  @override
  String get refreshUsers => 'Обновить список пользователей';

  @override
  String get changePseudoTooltip => 'Изменить мой псевдоним';

  @override
  String get userProfile => 'Профиль';

  @override
  String p2pSecureSubtitle(String id) {
    return 'Безопасный P2P • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Очистить беседу';

  @override
  String get addCoinsTooltip => 'Дать монеты';

  @override
  String get coinsToAddLabel => 'Количество добавляемых монет';

  @override
  String get messageSigmaPlaceholder => 'Сообщение Sigma...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'Профиль пользователя';

  @override
  String get tabInfo => 'Инфо';

  @override
  String get tabActivity => 'Активность';

  @override
  String get tabSecurity => 'Безопасность';

  @override
  String get tabNetwork => 'Сеть';

  @override
  String get identity => 'Личность';

  @override
  String get deviceAndSession => 'Устройство и сессия';

  @override
  String get lastActivity => 'Последняя активность';

  @override
  String get createdAt => 'Создано';

  @override
  String get activitySummary => 'Сводка активности';

  @override
  String get eventsCollected => 'Событий собрано';

  @override
  String get validGpsPoints => 'Верных точек GPS';

  @override
  String get maxContactsSeen => 'Макс. увиденных контактов';

  @override
  String get securityStatus => 'Статус безопасности';

  @override
  String get activeSession => 'Активная сессия';

  @override
  String get lastPing => 'Последний пинг';

  @override
  String agoMin(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String get anomalyDetected => 'Обнаружена аномалия';

  @override
  String get none => 'Нет (локальная эвристика)';

  @override
  String get securityNote =>
      'Примечание: эта вкладка отображает сигналы безопасности приложения на основе доступных данных (не является полным аудитом сервера).';

  @override
  String get networkStatus => 'Статус сети';

  @override
  String get mainChannel => 'Основной канал';

  @override
  String get presence => 'Присутствие';

  @override
  String get available => 'Доступен';

  @override
  String get unavailable => 'Недоступен';

  @override
  String get geolocSamples => 'Образцы геолокации';

  @override
  String get rawDebugData => 'Сырые данные (отладка)';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get sigmaAdProposalTitle => '🚀 Предложите свое объявление Sigma';

  @override
  String get submitAdSuccess =>
      '✅ Заявка отправлена! Дождитесь проверки админом для получения монет.';

  @override
  String get submitAdInfo =>
      'Отправьте изображение, описание и заработайте монеты!';

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get submit => 'Отправить';

  @override
  String get bonusActivated => 'Бонус монет активирован! (Видео просмотрено)';

  @override
  String get watchVideoBonus => 'Посмотреть видео за +50 бонусных монет';

  @override
  String get languageSelectorTitle => 'Select Language / Выберите язык';

  @override
  String get imageLinkUrl => 'Ссылка на изображение (URL)';

  @override
  String get bonusAddedText => 'Бонус монет активирован! (Видео просмотрено)';

  @override
  String get close => 'Закрыть';

  @override
  String copiedToClipboard(String text) {
    return 'Ключ скопирован: $text';
  }

  @override
  String get disconnectTooltip => 'Отключить';

  @override
  String get connectTooltip => 'Рассчитать и подключить';

  @override
  String get audioUnavailable => 'Голосовое сообщение недоступно.';

  @override
  String get supportSigmaPro => 'Поддержка Sigma Pro';

  @override
  String get p2pEncryptedChat => 'Зашифрованные P2P-сообщения';

  @override
  String get needHelpMessage => 'Нужна помощь? Напишите нам.';

  @override
  String get chooseAdminRole => 'Выберите роль администратора';

  @override
  String get configRequiredTitle => 'Требуется настройка';

  @override
  String get configRequiredInfo => 'Для работы Sigma необходимо: \n';

  @override
  String get configVisibleNote =>
      'Без этого вы не будете видны на карте Sigma.';

  @override
  String get configureNow => 'Настроить сейчас';

  @override
  String get accessDenied => 'Доступ запрещен.';

  @override
  String sigmaKey(String key) {
    return 'Ключ Sigma: $key';
  }

  @override
  String get wifiDisabled => 'WiFi выключен.';

  @override
  String get locationWifiPermsRequired =>
      'Требуются разрешения на местоположение/WiFi.';

  @override
  String get gpsRequiredAndroid => 'Для сканирования на Android требуется GPS.';

  @override
  String get noCompatibleNetworks =>
      'Совместимых сетей поблизости не обнаружено.';

  @override
  String scanError(String error) {
    return 'Ошибка сканирования: $error';
  }

  @override
  String get scanNotSupported =>
      'Сканирование WiFi не поддерживается на этом устройстве.';

  @override
  String get gpsDisabled => 'GPS выключен.';

  @override
  String scanUnavailable(String status) {
    return 'Сканирование недоступно ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Введите ключ вручную, если соединение не удалось.';

  @override
  String get authRequired => 'Требуется аутентификация';

  @override
  String get chooseRole => 'Выберите свою роль';

  @override
  String get user => 'Пользователь';

  @override
  String get validate => 'Проверить';

  @override
  String get authTitle => 'Аутентификация';

  @override
  String get commerceLogin => 'Вход в коммерцию';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get loginGoogle => 'Продолжить через Google';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get hasAccount => 'Уже есть аккаунт? Войти';

  @override
  String get resetEmailSent => 'Письмо для сброса пароля отправлено!';

  @override
  String get fillAllFields => 'Пожалуйста, заполните все поля.';

  @override
  String googleError(String error) {
    return 'Ошибка Google: $error';
  }

  @override
  String get permsRequiredTitle => 'Требуются разрешения';

  @override
  String get permsRequiredInfo =>
      'Для использования этого приложения вы должны:\n\n';

  @override
  String get permsFatalNote => 'Без этого приложение не сможет работать.';

  @override
  String get understandAndConfigure => 'Я понял, настроить';

  @override
  String get commerceDisconnectConfirm => 'Вы хотите выйти из коммерции?';

  @override
  String get startDiscussion => 'Начать обсуждение';

  @override
  String get yourMessage => 'Ваше сообщение...';

  @override
  String get orderErrorUnidentified =>
      'Невозможно оформить заказ: пользователь не идентифицирован.';

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
