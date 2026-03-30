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
  String get messengerDashboard => '?????? Sigma Messenger';

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
  String get supportChatPlaceholder => '????????? ? ?????????...';

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
  String get email => '??. ?????';

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
  String get client => '??????';

  @override
  String get vendor => '????????';

  @override
  String get deliveryPerson => '??????';

  @override
  String get wholesaler => '???????';

  @override
  String get vocalSigma => '????? Sigma';

  @override
  String get defaultMessageContent => '?????????';

  @override
  String get myContacts => '??? ????????';

  @override
  String get myQrCodeTooltip => '??? QR-???';

  @override
  String get scanFriendTooltip => '??????????? ?????';

  @override
  String get friendAddedSuccess => '? ???? ??????? ????????!';

  @override
  String get editPseudoMenu => '???????? ?????????';

  @override
  String get myPseudoTitle => '??? ?????????';

  @override
  String get enterPseudoHint => '??????? ?????????';

  @override
  String get noContacts => '??? ?????????';

  @override
  String get scanFriendToStart => '?????????? QR-??? ?????, ????? ??????';

  @override
  String get scanFriendButton => '??????????? ?????';

  @override
  String get addedOn => '?????????';

  @override
  String get scanQrCodeTitle => '??????????? QR-???';

  @override
  String get qrCodeUnreadable => 'QR-??? ????????, ?????????? ?????.';

  @override
  String get invalidMistralQr => '???? QR-??? ?? ?? Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return '???????? ??????: $error';
  }

  @override
  String get cannotAddSelf => '?? ?? ?? ?????? ???????? ????!';

  @override
  String get friendAlreadyAdded => '?? ???? ???? ??? ? ????? ?????????.';

  @override
  String get placeQrInFrame => '????????? QR-??? ? ?????';

  @override
  String get retry => '?????????';

  @override
  String get flashlightTooltip => '???????';

  @override
  String get shareLinkTooltip => '?????????? ???????';

  @override
  String inviteText(String link) {
    return '?????? ???? ? Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => '??????????? Mistral2laude P2P';

  @override
  String get scanMeText =>
      '?????????? ???? QR-???\n????? ???????? ???? ? ????????';

  @override
  String get microphonePermissionDenied => '?????? ? ????????? ????????';

  @override
  String get connectionNotEstablished =>
      '?? ?????????? ?? ???????????. ????????? ????????? ????????.';

  @override
  String get noMessagesYet => '????????? ???.\n????????? ??????! ??';

  @override
  String get statusConnected => '??????????';

  @override
  String get statusConnecting => '???????????...';

  @override
  String get statusFailed => '??????';

  @override
  String get statusOffline => '?? ? ????';

  @override
  String get recordingHint => '?? ??????...';

  @override
  String get messageHint => '?????????...';

  @override
  String get connectingHint => '???????????...';

  @override
  String get initFailed => '????????????? ?? ???????';

  @override
  String get defaultUserPseudo => '???????????? M2C';

  @override
  String get mobileDevice => '????????? ??????????';

  @override
  String get unknownDevice => '??????????? ??????????';

  @override
  String get productsTab => '??????';

  @override
  String get logisticsTab => 'Logistics';

  @override
  String get ordersTab => '??????';

  @override
  String get cartTab => '???????';

  @override
  String get toPickUp => 'To Pick Up';

  @override
  String get toPrepare => 'To Prepare';

  @override
  String get toDeliver => 'To Deliver';

  @override
  String get clientModeTooltip => '????? ???????';

  @override
  String get adminModeTooltip => '????? ??????????????';

  @override
  String get addProductTooltip => '???????? ?????';

  @override
  String get orderCreated => '????? ??????.';

  @override
  String get orderFailed => '?????? ??????.';

  @override
  String get productCreated => '????? ??????.';

  @override
  String get productUpdated => '????? ????????.';

  @override
  String get productDeleted => '????? ??????.';

  @override
  String get deleteFailed => '?? ??????? ???????.';

  @override
  String get deleteProductTitle => '??????? ?????';

  @override
  String deleteProductConfirm(String name) {
    return '??????? \"$name\"?';
  }

  @override
  String get imageUploaded => '??????????? ?????????.';

  @override
  String imageUploadFailed(String error) {
    return '?????? ???????? ???????????: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Bucket ??????????? Supabase ?? ????????.';

  @override
  String get searchProductsPlaceholder => '????? ??????? ??? SKU';

  @override
  String get inStockFilter => '? ???????';

  @override
  String get includeInactiveFilter => '???????? ??????????';

  @override
  String get sortName => '????????';

  @override
  String get sortPriceAsc => '???? ?? ???????????';

  @override
  String get sortPriceDesc => '???? ?? ????????';

  @override
  String get sortStockAsc => '??????? ?? ???????????';

  @override
  String get sortStockDesc => '??????? ?? ????????';

  @override
  String get sortPopularity => '????????????';

  @override
  String get gridView => '?????';

  @override
  String get listView => '??????';

  @override
  String get noProductsMatch => '??? ???????, ??????????????? ????????.';

  @override
  String get clearFilters => '???????? ???????';

  @override
  String get allProductsLoaded => '??? ?????? ?????????.';

  @override
  String get saveProductTitle => '????????? ?????';

  @override
  String get addProductTitle => '???????? ?????';

  @override
  String get editProductTitle => '????????????? ?????';

  @override
  String get productNameLabel => '????????';

  @override
  String get skuLabel => 'SKU / ??????';

  @override
  String get priceLabel => '???? (DZD)';

  @override
  String get promoPriceLabel => '????? ???? (DZD)';

  @override
  String get optionalHelper => '?????????????';

  @override
  String get imageLabel => 'URL ??????????? ??? ???? ????????';

  @override
  String get uploadImageButton => '????????? ???????????';

  @override
  String get replaceImageButton => '???????? ???????????';

  @override
  String get uploadingButton => '????????...';

  @override
  String get stockLabel => '???????';

  @override
  String get popularityLabel => '????????????';

  @override
  String get activeLabel => '????????';

  @override
  String get saveButton => '?????????';

  @override
  String get savingButton => '??????????...';

  @override
  String get unavailableStatus => '??????????';

  @override
  String get outOfStockStatus => '??? ? ???????';

  @override
  String get lowStockStatus => '?????? ???????';

  @override
  String get inactiveStatus => '??????????';

  @override
  String get promoStatus => '?????';

  @override
  String get cartEmpty => '??????? ?????.';

  @override
  String get yourCart => '???? ???????';

  @override
  String get clearCart => '????????';

  @override
  String get subtotalLabel => '????????????? ????';

  @override
  String get deliveryLabel => '????????';

  @override
  String get totalLabel => '?????';

  @override
  String get phoneLabel => '???????';

  @override
  String get addressLabel => '?????';

  @override
  String get noteLabel => '??????????';

  @override
  String get checkoutButton => '???????? ?????';

  @override
  String orderTotal(String amount) {
    return '????? $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count ??.';
  }

  @override
  String orderNumber(String id) {
    return '????? #$id';
  }

  @override
  String get changeRoleTooltip => '??????? ???? (?????????)';

  @override
  String get orderNotFound => '????? ?? ??????';

  @override
  String get globalStatus => '????? ??????';

  @override
  String get dateLabel => '????';

  @override
  String get customerLabel => '??????';

  @override
  String get paymentLabel => '??????';

  @override
  String get productsLabel => '??????';

  @override
  String priceXQuantity(String price, int quantity) {
    return '????: $price DZD x $quantity';
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
  String get noShipmentsYet => '???? ??? ???????????.';

  @override
  String shipmentsCount(int count) {
    return '??????????? ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return '???????: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return '??????????: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => '??????????';

  @override
  String get itemsInPackage => '?????? ? ???? ???????:';

  @override
  String get confirmOrderButton => '??????????? ?????';

  @override
  String get allocateStockButton => '???????????? ?????';

  @override
  String get startPickingButton => '?????? ????';

  @override
  String get packingFinishedButton => '???????? ????????? (?????????)';

  @override
  String get shipButton => '??????? ???????? ? ?????????';

  @override
  String setInTransitButton(String tracking) {
    return '? ???? ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return '??????????? ???????? ($tracking)';
  }

  @override
  String get requestReturnButton => '????????? ???????';

  @override
  String get newShipmentTitle => '????? ????????';

  @override
  String get allItemIncludedNote =>
      '??? ?????? ????? ???????? ? ??? ??????? ??? ???????.';

  @override
  String get trackingNumberLabel => '????? ????????????';

  @override
  String get adminStatusTitle => '????????????????? : ??????';

  @override
  String get phoneAddressRequired => '??????? ? ????? ???????????.';

  @override
  String get orderFailedLong => '?????? ??????.';

  @override
  String orderCreatedLong(String id) {
    return '????? ??????: $id';
  }

  @override
  String get placingOrderButton => '?????????? ??????...';

  @override
  String get placeOrderButton => '???????? ?????';

  @override
  String get loadMoreButton => '????????? ???';

  @override
  String get searchOrderPlaceholder => '????? ??????...';

  @override
  String get allFilter => '???';

  @override
  String get orderConfirmedStep => '????????????';

  @override
  String get shippedStep => '??????????';

  @override
  String get deliveredStep => '??????????';

  @override
  String get unknownDate => '??????????';

  @override
  String get p2pMessengerTitle => 'P2P-??????????';

  @override
  String errorWithDetails(String message) {
    return '??????: $message';
  }

  @override
  String get myQrCode => '??? QR-???';

  @override
  String get shareQrCodeTitle => '?????????? ????? QR-?????';

  @override
  String get shareQrCodeSubtitle =>
      '????? ???? ?????? ??????????? ???? ???, ????? ???????? ??? ? ????????.';

  @override
  String get takeScreenshotToShare =>
      '???????? ????????, ????? ?????????? QR-?????.';

  @override
  String get initErrorTitle => '?????? ?????????????';

  @override
  String get messagesTitle => '?????????';

  @override
  String get addContactTooltip => '???????? ???????';

  @override
  String get noConversations => '???? ??? ??????????';

  @override
  String get addContactToStart => '???????? ???????, ????? ?????? ???';

  @override
  String get typingStatus => '????????...';

  @override
  String get sayHello => '??????? ??????! ??';

  @override
  String get yesterday => '?????';

  @override
  String get addFriendTitle => '???????? ?????';

  @override
  String get scanFriendQr => '?????????? QR-??? ?????';

  @override
  String get addContactTitle => '???????? ???????';

  @override
  String get yourQrCodeTitle => '??? QR-???';

  @override
  String get yourQrCodeSubtitle => '???????? ???? ??? ?????';

  @override
  String get notAvailable => '?/?';

  @override
  String get deviceIdLabel => 'ID устройства';

  @override
  String get contactAddedSuccess => '??????? ??????? ????????!';

  @override
  String get dataChannelDisconnected => '????? ?????? ????????';

  @override
  String peerNotConnected(String id) {
    return '??? ?? ?????????: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return '?????? ??????? ?????????: $error';
  }

  @override
  String invalidQrCode(String error) {
    return '???????? QR-???: $error';
  }

  @override
  String get missingDeviceId => 'Отсутствует ID устройства';

  @override
  String get missingPseudo => '??????????? ?????????';

  @override
  String get missingPublicKey => '??????????? ????????? ????';

  @override
  String get cannotAddSelfError => '?????? ???????? ????';

  @override
  String get invalidPublicKeyFormat => '???????? ?????? ?????????? ?????';

  @override
  String errorParsingQrCode(String error) {
    return '?????? ??????? QR-????: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => '????';

  @override
  String get encryptedMessage => '[????????????? ?????????]';

  @override
  String get youEncryptedMessage => '??: [????????????? ?????????]';

  @override
  String get imageMessage => '??? ???????????';

  @override
  String get fileMessage => '?? ????';

  @override
  String get newMessage => '????? ?????????';

  @override
  String get reply => '????????';

  @override
  String get quickReply => '??????? ?????';

  @override
  String get markAsRead => '???????? ??? ???????????';

  @override
  String get isTyping => '????????...';

  @override
  String get typingIndicator => '????????...';

  @override
  String get vocalMessage => '????????? ?????????';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => '??????????';

  @override
  String get trace => '???????????';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Пожалуйста, исправьте ошибки в форме.';

  @override
  String get saveFailed => 'Сохранение не удалось.';

  @override
  String get itemsLabel => 'Товары';

  @override
  String get productInfoSection => 'Информация';

  @override
  String get productImageSection => 'Изображение';

  @override
  String get productStockStatusSection => 'Запас и статус';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get nameRequired => 'Название обязательно';

  @override
  String get priceRequired => 'Цена обязательна';

  @override
  String get invalidPrice => 'Введите корректную цену';

  @override
  String get invalidPromoPrice => 'Введите корректную промо-цену';

  @override
  String get promoLowerThanPrice => 'Промо-цена должна быть ниже цены';

  @override
  String get invalidStock => 'Введите корректный запас';

  @override
  String get popularityHelper => 'Чем выше, тем популярнее';

  @override
  String get invalidPopularity => 'Введите корректную популярность';

  @override
  String get addToCart => 'Добавить в корзину';

  @override
  String get stockUnknown => 'Запас неизвестен';

  @override
  String get startChatPrompt => 'Начните разговор';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (В реальном времени)';

  @override
  String get clear => 'Очистить';

  @override
  String get warehouseRole => 'Склад';

  @override
  String get carrierRole => 'Перевозчик';

  @override
  String get supportRole => 'Поддержка';

  @override
  String get orderStatusCreated => 'Создана';

  @override
  String get orderStatusPendingPayment => 'Ожидает оплаты';

  @override
  String get orderStatusPaid => 'Оплачена';

  @override
  String get orderStatusPaymentFailed => 'Оплата не прошла';

  @override
  String get orderStatusCancelRequested => 'Запрошена отмена';

  @override
  String get orderStatusCancelled => 'Отменена';

  @override
  String get orderStatusOrderConfirmed => 'Подтверждена';

  @override
  String get orderStatusStockAllocated => 'Запас выделен';

  @override
  String get orderStatusBackorder => 'Ожидание поставки';

  @override
  String get orderStatusPicking => 'Комплектация';

  @override
  String get orderStatusPacked => 'Упакована';

  @override
  String get orderStatusReadyToShip => 'Готова к отправке';

  @override
  String get orderStatusPartiallyShipped => 'Частично отправлена';

  @override
  String get orderStatusShipped => 'Отправлена';

  @override
  String get orderStatusPartiallyDelivered => 'Частично доставлена';

  @override
  String get orderStatusDelivered => 'Доставлена';

  @override
  String get orderStatusDeliveryFailed => 'Доставка не удалась';

  @override
  String get orderStatusException => 'Исключение';

  @override
  String get orderStatusReturnRequested => 'Запрошен возврат';

  @override
  String get orderStatusReturnInTransit => 'Возврат в пути';

  @override
  String get orderStatusReturnReceived => 'Возврат получен';

  @override
  String get orderStatusRefundPending => 'Возврат средств ожидается';

  @override
  String get orderStatusRefunded => 'Возвращено';

  @override
  String get orderStatusClosed => 'Закрыта';

  @override
  String get shipmentStatusLabelCreated => 'Этикетка создана';

  @override
  String get shipmentStatusPickedUp => 'Получено';

  @override
  String get shipmentStatusInTransit => 'В пути';

  @override
  String get shipmentStatusArrivedAtHub => 'Прибыло в хаб';

  @override
  String get shipmentStatusCustomsClearance => 'Таможенное оформление';

  @override
  String get shipmentStatusOutForDelivery => 'Курьер доставляет';

  @override
  String get shipmentStatusDelivered => 'Доставлено';

  @override
  String get shipmentStatusDeliveryFailed => 'Доставка не удалась';

  @override
  String get shipmentStatusException => 'Исключение';

  @override
  String get shipmentStatusLost => 'Утеряно';

  @override
  String get shipmentStatusDamaged => 'Повреждено';

  @override
  String get shipmentStatusReturnToSender => 'Возврат отправителю';

  @override
  String get returnStatusRequested => 'Запрошен';

  @override
  String get returnStatusAuthorized => 'Авторизован';

  @override
  String get returnStatusLabelIssued => 'Этикетка выдана';

  @override
  String get returnStatusInTransit => 'В пути';

  @override
  String get returnStatusReceived => 'Получен';

  @override
  String get returnStatusRejected => 'Отклонен';

  @override
  String get returnStatusRefundPending => 'Возврат средств ожидается';

  @override
  String get returnStatusRefunded => 'Возвращено';

  @override
  String get paymentStatusPending => 'В ожидании';

  @override
  String get paymentStatusAuthorized => 'Авторизовано';

  @override
  String get paymentStatusCaptured => 'Списано';

  @override
  String get paymentStatusVoided => 'Отменено';

  @override
  String get paymentStatusRefunded => 'Возвращено';

  @override
  String get paymentStatusFailed => 'Не удалось';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'Бестселлер';

  @override
  String get readMore => 'читать далее';

  @override
  String get showLess => 'свернуть';
}
