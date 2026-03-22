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
  String confirmDeleteConversation(Object pseudo) {
    return 'Удалить все сообщения с $pseudo?';
  }

  @override
  String get conversationDeleted => 'Беседа удалена локально.';

  @override
  String get p2pSecure => 'Безопасный P2P';

  @override
  String coinsForUser(Object pseudo) {
    return 'Монеты для $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'Ошибка сканирования: $error';
  }

  @override
  String get scanNotSupported =>
      'Сканирование WiFi не поддерживается на этом устройстве.';

  @override
  String get gpsDisabled => 'GPS выключен.';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
