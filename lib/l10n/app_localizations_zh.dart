// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => '首页';

  @override
  String get map => '地图';

  @override
  String get scan => '扫描';

  @override
  String get settings => '设置';

  @override
  String get admin => '管理员';

  @override
  String get commerce => '商务';

  @override
  String get p2pChat => 'P2P 聊天';

  @override
  String get publishAd => '发布广告';

  @override
  String get connect => '连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get copy => '复制';

  @override
  String get share => '分享';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get edit => '修改';

  @override
  String get save => '保存';

  @override
  String get search => '搜索';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get password => '密码';

  @override
  String get pseudo => '昵称';

  @override
  String get login => '登录';

  @override
  String get logout => '注销';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '系统';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get profileTooltip => '个人资料';

  @override
  String get adminTooltip => '管理员';

  @override
  String get chatTooltip => '聊天';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => '扫描 WiFi';

  @override
  String get scanning => '正在分析...';

  @override
  String get noNetworks => '未发现网络';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String get fixPermissions => '修复权限';

  @override
  String get detected => '已检测到';

  @override
  String get connected => '已连接';

  @override
  String get failed => '失败';

  @override
  String get coins => '金币';

  @override
  String get publishAdEarn => '发布广告赚取金币';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => '已从管理员断开连接。';

  @override
  String get logoutTooltip => '本地注销';

  @override
  String get tabStats => '统计';

  @override
  String get tabAds => '广告';

  @override
  String get tabTargets => '目标';

  @override
  String get tabMap => '地图';

  @override
  String get tabTraces => '踪迹';

  @override
  String get tabContacts => '联系人';

  @override
  String get tabConfig => '配置';

  @override
  String get securityAdmin => '🔐 管理员安全';

  @override
  String get changePasswordInfo => '更改控制面板访问密码。此更改将立即应用于所有设备。';

  @override
  String get minPasswordError => '密码必须至少包含 6 个字符。';

  @override
  String get passwordUpdateSuccess => '✅ Supabase 上的管理员密码已更新！';

  @override
  String get passwordUpdateError => '❌ 更新时出错。';

  @override
  String get addCarousel => '📢 添加到轮播图';

  @override
  String get saveChanges => '保存更改';

  @override
  String get newPassword => '新密码';

  @override
  String get publish => '发布';

  @override
  String get bannerAdded => '横幅已添加！';

  @override
  String get userSubmissionsManagement => '用户提交管理';

  @override
  String get unknown => '未知';

  @override
  String get model => '型号';

  @override
  String get coinsLabel => '金币';

  @override
  String get chat => '聊天';

  @override
  String get giveCoins => '赠送金币';

  @override
  String get coinsAmountLabel => '金币数量';

  @override
  String get add => '添加';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get searchPlaceholder => '搜索...';

  @override
  String get bannerText => '横幅文字';

  @override
  String get imageUrl => '图片 URL';

  @override
  String get externalLink => '外部链接';

  @override
  String get editPseudo => '修改我的昵称';

  @override
  String get newPseudo => '新昵称';

  @override
  String get pseudoUpdated => '昵称已更新！';

  @override
  String get pseudoError => '昵称不可用或出错。';

  @override
  String get messengerDashboard => 'Sigma Messenger ???';

  @override
  String get noUsersFound => '未找到用户。';

  @override
  String get noActivityAvailable => '没有可用的活动。';

  @override
  String get deleteConversation => '清除对话';

  @override
  String confirmDeleteConversation(String pseudo) {
    return '删除与 $pseudo 的所有消息？';
  }

  @override
  String get conversationDeleted => '本地对话已删除。';

  @override
  String get p2pSecure => '安全 P2P';

  @override
  String coinsForUser(String pseudo) {
    return '给 $pseudo 的金币';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '已向 $pseudo 添加 $amount 个金币';
  }

  @override
  String get amountLabel => '金额';

  @override
  String get addCoins => '添加金币';

  @override
  String get refreshUsers => '刷新用户';

  @override
  String get changePseudoTooltip => '更改我的昵称';

  @override
  String get userProfile => '个人资料';

  @override
  String p2pSecureSubtitle(String id) {
    return '安全 P2P • $id...';
  }

  @override
  String get deleteConversationTooltip => '清除对话';

  @override
  String get addCoinsTooltip => '赠送金币';

  @override
  String get coinsToAddLabel => '要添加的金币数量';

  @override
  String get messageSigmaPlaceholder => 'Sigma 消息...';

  @override
  String get supportChatPlaceholder => '???????...';

  @override
  String get userProfileTitle => '用户个人资料';

  @override
  String get tabInfo => '信息';

  @override
  String get tabActivity => '活动';

  @override
  String get tabSecurity => '安全';

  @override
  String get tabNetwork => '网络';

  @override
  String get identity => '身份';

  @override
  String get deviceAndSession => '设备与会话';

  @override
  String get lastActivity => '最后活动';

  @override
  String get createdAt => '创建于';

  @override
  String get activitySummary => '活动摘要';

  @override
  String get eventsCollected => '收集的事件';

  @override
  String get validGpsPoints => '有效 GPS 点';

  @override
  String get maxContactsSeen => '最大接触数';

  @override
  String get securityStatus => '安全状态';

  @override
  String get activeSession => '活动会话';

  @override
  String get lastPing => '最后心跳';

  @override
  String agoMin(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String get anomalyDetected => '检测到异常';

  @override
  String get none => '无（本地启发式）';

  @override
  String get securityNote => '注：此标签页显示基于可用数据的应用安全信号（非完整服务器审计）。';

  @override
  String get networkStatus => '网络状态';

  @override
  String get mainChannel => '主频道';

  @override
  String get presence => '在离线状态';

  @override
  String get available => '在线';

  @override
  String get unavailable => '离线';

  @override
  String get geolocSamples => '地理位置样本';

  @override
  String get rawDebugData => '原始调试数据';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get sigmaAdProposalTitle => '🚀 提交您的 Sigma 广告';

  @override
  String get submitAdSuccess => '✅ 提交成功！请等待管理员审核以获取金币。';

  @override
  String get submitAdInfo => '发送图片和描述以赚取金币！';

  @override
  String get descriptionLabel => '描述';

  @override
  String get submit => '提交';

  @override
  String get bonusActivated => '金币奖励已激活！（已观看视频）';

  @override
  String get watchVideoBonus => '观看视频获取 +50 奖励金币';

  @override
  String get languageSelectorTitle => 'Select Language / 选择语言';

  @override
  String get imageLinkUrl => '图片链接 (URL)';

  @override
  String get bonusAddedText => '金币奖励已激活！（已观看视频）';

  @override
  String get close => '关闭';

  @override
  String copiedToClipboard(String text) {
    return '密钥已复制：$text';
  }

  @override
  String get disconnectTooltip => '断开连接';

  @override
  String get connectTooltip => '计算并连接';

  @override
  String get audioUnavailable => '语音不可用。';

  @override
  String get supportSigmaPro => 'Sigma Pro 支持';

  @override
  String get p2pEncryptedChat => '加密 P2P 消息';

  @override
  String get needHelpMessage => '需要帮助？给我们发送消息。';

  @override
  String get chooseAdminRole => '选择您的管理员角色';

  @override
  String get configRequiredTitle => '需要配置';

  @override
  String get configRequiredInfo => '为了运行，Sigma 需要： \n';

  @override
  String get configVisibleNote => '如果不这样做，您将无法在 Sigma 地图上显示。';

  @override
  String get configureNow => '立即配置';

  @override
  String get accessDenied => '拒绝访问。';

  @override
  String sigmaKey(String key) {
    return 'Sigma 密钥: $key';
  }

  @override
  String get wifiDisabled => 'WiFi 已禁用。';

  @override
  String get locationWifiPermsRequired => '需要位置/WiFi 权限。';

  @override
  String get gpsRequiredAndroid => 'Android 扫描需要 GPS。';

  @override
  String get noCompatibleNetworks => '附近未检测到兼容网络。';

  @override
  String scanError(String error) {
    return '扫描错误: $error';
  }

  @override
  String get scanNotSupported => '此设备不支持 WiFi 扫描。';

  @override
  String get gpsDisabled => 'GPS 已禁用。';

  @override
  String scanUnavailable(String status) {
    return '扫描不可用 ($status)。';
  }

  @override
  String get manualKeyEntryNote => '如果连接失败，请手动输入密钥。';

  @override
  String get authRequired => '需要身份验证';

  @override
  String get chooseRole => '选择您的角色';

  @override
  String get user => '用户';

  @override
  String get validate => '验证';

  @override
  String get authTitle => '身份验证';

  @override
  String get commerceLogin => '商务登录';

  @override
  String get createAccount => '创建账户';

  @override
  String get email => '电子邮件';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get loginGoogle => '继续使用 Google';

  @override
  String get noAccount => '没有账户？注册';

  @override
  String get hasAccount => '已有账户？登录';

  @override
  String get resetEmailSent => '重置邮件已发送！';

  @override
  String get fillAllFields => '请填写所有字段。';

  @override
  String googleError(String error) {
    return 'Google 错误: $error';
  }

  @override
  String get permsRequiredTitle => '需要权限';

  @override
  String get permsRequiredInfo => '要使用此应用，您必须：\n\n';

  @override
  String get permsFatalNote => '如果不这样做，应用将无法运行。';

  @override
  String get understandAndConfigure => '我了解，去配置';

  @override
  String get commerceDisconnectConfirm => '您要退出商务吗？';

  @override
  String get startDiscussion => '开始讨论';

  @override
  String get yourMessage => '您的消息...';

  @override
  String get orderErrorUnidentified => '无法下订单：用户身份未识别。';

  @override
  String get client => '??';

  @override
  String get vendor => '??';

  @override
  String get deliveryPerson => '???';

  @override
  String get wholesaler => '???';

  @override
  String get vocalSigma => 'Sigma ??';

  @override
  String get defaultMessageContent => '??';

  @override
  String get myContacts => '?????';

  @override
  String get myQrCodeTooltip => '?????';

  @override
  String get scanFriendTooltip => '????';

  @override
  String get friendAddedSuccess => '? ????????';

  @override
  String get editPseudoMenu => '????';

  @override
  String get myPseudoTitle => '????';

  @override
  String get enterPseudoHint => '??????';

  @override
  String get noContacts => '?????';

  @override
  String get scanFriendToStart => '???????????';

  @override
  String get scanFriendButton => '????';

  @override
  String get addedOn => '???';

  @override
  String get scanQrCodeTitle => '?????';

  @override
  String get qrCodeUnreadable => '????????????';

  @override
  String get invalidMistralQr => '???????? Mistral P2P?';

  @override
  String invalidLinkError(String error) {
    return '?????$error';
  }

  @override
  String get cannotAddSelf => '?? ???????';

  @override
  String get friendAlreadyAdded => '?? ????????????';

  @override
  String get placeQrInFrame => '????????';

  @override
  String get retry => '??';

  @override
  String get flashlightTooltip => '???';

  @override
  String get shareLinkTooltip => '????';

  @override
  String inviteText(String link) {
    return '? Mistral2laude P2P ?????\n$link';
  }

  @override
  String get inviteSubject => 'Mistral2laude P2P ??';

  @override
  String get scanMeText => '??????\n?????????';

  @override
  String get microphonePermissionDenied => '????????';

  @override
  String get connectionNotEstablished => '?? ??????????????';

  @override
  String get noMessagesYet => '?????\n??????? ??';

  @override
  String get statusConnected => '???';

  @override
  String get statusConnecting => '???...';

  @override
  String get statusFailed => '??';

  @override
  String get statusOffline => '??';

  @override
  String get recordingHint => '?? ???...';

  @override
  String get messageHint => '??...';

  @override
  String get connectingHint => '???...';

  @override
  String get initFailed => '?????';

  @override
  String get defaultUserPseudo => 'M2C ??';

  @override
  String get mobileDevice => '????';

  @override
  String get unknownDevice => '????';

  @override
  String get productsTab => '??';

  @override
  String get logisticsTab => 'Logistics';

  @override
  String get ordersTab => '??';

  @override
  String get cartTab => '???';

  @override
  String get toPickUp => 'To Pick Up';

  @override
  String get toPrepare => 'To Prepare';

  @override
  String get toDeliver => 'To Deliver';

  @override
  String get clientModeTooltip => '????';

  @override
  String get adminModeTooltip => '?????';

  @override
  String get addProductTooltip => '????';

  @override
  String get orderCreated => '??????';

  @override
  String get orderFailed => '?????';

  @override
  String get productCreated => '??????';

  @override
  String get productUpdated => '??????';

  @override
  String get productDeleted => '??????';

  @override
  String get deleteFailed => '?????';

  @override
  String get deleteProductTitle => '????';

  @override
  String deleteProductConfirm(String name) {
    return '???$name??';
  }

  @override
  String get imageUploaded => '??????';

  @override
  String imageUploadFailed(String error) {
    return '???????$error';
  }

  @override
  String get supabaseBucketNotConfigured => 'Supabase ???????';

  @override
  String get searchProductsPlaceholder => '????? SKU';

  @override
  String get inStockFilter => '???';

  @override
  String get includeInactiveFilter => '?????';

  @override
  String get sortName => '??';

  @override
  String get sortPriceAsc => '??????';

  @override
  String get sortPriceDesc => '??????';

  @override
  String get sortStockAsc => '??????';

  @override
  String get sortStockDesc => '??????';

  @override
  String get sortPopularity => '???';

  @override
  String get gridView => '??';

  @override
  String get listView => '??';

  @override
  String get noProductsMatch => '????????????';

  @override
  String get clearFilters => '????';

  @override
  String get allProductsLoaded => '????????';

  @override
  String get saveProductTitle => '????';

  @override
  String get addProductTitle => '????';

  @override
  String get editProductTitle => '????';

  @override
  String get productNameLabel => '??';

  @override
  String get skuLabel => 'SKU / ??';

  @override
  String get priceLabel => '?? (DZD)';

  @override
  String get promoPriceLabel => '??? (DZD)';

  @override
  String get optionalHelper => '??';

  @override
  String get imageLabel => '?? URL ?????';

  @override
  String get uploadImageButton => '????';

  @override
  String get replaceImageButton => '????';

  @override
  String get uploadingButton => '???...';

  @override
  String get stockLabel => '??';

  @override
  String get popularityLabel => '???';

  @override
  String get activeLabel => '??';

  @override
  String get saveButton => '??';

  @override
  String get savingButton => '???...';

  @override
  String get unavailableStatus => '???';

  @override
  String get outOfStockStatus => '??';

  @override
  String get lowStockStatus => '????';

  @override
  String get inactiveStatus => '???';

  @override
  String get promoStatus => '??';

  @override
  String get cartEmpty => '??????';

  @override
  String get yourCart => '?????';

  @override
  String get clearCart => '??';

  @override
  String get subtotalLabel => '??';

  @override
  String get deliveryLabel => '??';

  @override
  String get totalLabel => '??';

  @override
  String get phoneLabel => '??';

  @override
  String get addressLabel => '??';

  @override
  String get noteLabel => '??';

  @override
  String get checkoutButton => '??';

  @override
  String orderTotal(String amount) {
    return '?? $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count ?';
  }

  @override
  String orderNumber(String id) {
    return '?? #$id';
  }

  @override
  String get changeRoleTooltip => '????????';

  @override
  String get orderNotFound => '?????';

  @override
  String get globalStatus => '????';

  @override
  String get dateLabel => '??';

  @override
  String get customerLabel => '??';

  @override
  String get paymentLabel => '??';

  @override
  String get productsLabel => '??';

  @override
  String priceXQuantity(String price, int quantity) {
    return '???$price DZD ? $quantity';
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
  String get noShipmentsYet => '?????';

  @override
  String shipmentsCount(int count) {
    return '?? ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return '???$tracking';
  }

  @override
  String carrierLabel(String name) {
    return '????$name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => '????';

  @override
  String get itemsInPackage => '????????';

  @override
  String get confirmOrderButton => '????';

  @override
  String get allocateStockButton => '????';

  @override
  String get startPickingButton => '????';

  @override
  String get packingFinishedButton => '?????????';

  @override
  String get shipButton => '?????';

  @override
  String setInTransitButton(String tracking) {
    return '??????$tracking?';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return '?????$tracking?';
  }

  @override
  String get requestReturnButton => '????';

  @override
  String get newShipmentTitle => '???';

  @override
  String get allItemIncludedNote => '???????????';

  @override
  String get trackingNumberLabel => '???';

  @override
  String get adminStatusTitle => '?????';

  @override
  String get phoneAddressRequired => '?????????';

  @override
  String get orderFailedLong => '?????';

  @override
  String orderCreatedLong(String id) {
    return '??????$id';
  }

  @override
  String get placingOrderButton => '????...';

  @override
  String get placeOrderButton => '??';

  @override
  String get loadMoreButton => '????';

  @override
  String get searchOrderPlaceholder => '????...';

  @override
  String get allFilter => '??';

  @override
  String get orderConfirmedStep => '???';

  @override
  String get shippedStep => '???';

  @override
  String get deliveredStep => '???';

  @override
  String get unknownDate => '??';

  @override
  String get p2pMessengerTitle => 'P2P ??';

  @override
  String errorWithDetails(String message) {
    return '???$message';
  }

  @override
  String get myQrCode => '?????';

  @override
  String get shareQrCodeTitle => '???????';

  @override
  String get shareQrCodeSubtitle => '??????????????????';

  @override
  String get takeScreenshotToShare => '??????????';

  @override
  String get initErrorTitle => '?????';

  @override
  String get messagesTitle => '??';

  @override
  String get addContactTooltip => '?????';

  @override
  String get noConversations => '????';

  @override
  String get addContactToStart => '?????????';

  @override
  String get typingStatus => '????...';

  @override
  String get sayHello => '?????? ??';

  @override
  String get yesterday => '??';

  @override
  String get addFriendTitle => '????';

  @override
  String get scanFriendQr => '?????????';

  @override
  String get addContactTitle => '?????';

  @override
  String get yourQrCodeTitle => '?????';

  @override
  String get yourQrCodeSubtitle => '???????';

  @override
  String get notAvailable => '???';

  @override
  String get deviceIdLabel => '设备ID';

  @override
  String get contactAddedSuccess => '????????';

  @override
  String get dataChannelDisconnected => '???????';

  @override
  String peerNotConnected(String id) {
    return '??????$id';
  }

  @override
  String errorParsingMessage(String error) {
    return '???????$error';
  }

  @override
  String invalidQrCode(String error) {
    return '??????$error';
  }

  @override
  String get missingDeviceId => '缺少设备ID';

  @override
  String get missingPseudo => '????';

  @override
  String get missingPublicKey => '????';

  @override
  String get cannotAddSelfError => '??????';

  @override
  String get invalidPublicKeyFormat => '??????';

  @override
  String errorParsingQrCode(String error) {
    return '????????$error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => '??';

  @override
  String get encryptedMessage => '[????]';

  @override
  String get youEncryptedMessage => '??[????]';

  @override
  String get imageMessage => '??? ??';

  @override
  String get fileMessage => '?? ??';

  @override
  String get newMessage => '???';

  @override
  String get reply => '??';

  @override
  String get quickReply => '????';

  @override
  String get markAsRead => '?????';

  @override
  String get isTyping => '????...';

  @override
  String get typingIndicator => '????...';

  @override
  String get vocalMessage => '????';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => '??';

  @override
  String get trace => '??';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => '请修正表单错误。';

  @override
  String get saveFailed => '保存失败。';

  @override
  String get itemsLabel => '商品';

  @override
  String get productInfoSection => '信息';

  @override
  String get productImageSection => '图片';

  @override
  String get productStockStatusSection => '库存与状态';

  @override
  String get categoryLabel => '类别';

  @override
  String get nameRequired => '名称为必填项';

  @override
  String get priceRequired => '价格为必填项';

  @override
  String get invalidPrice => '请输入有效的价格';

  @override
  String get invalidPromoPrice => '请输入有效的促销价';

  @override
  String get promoLowerThanPrice => '促销价必须低于原价';

  @override
  String get invalidStock => '请输入有效的库存';

  @override
  String get popularityHelper => '数值越高越受欢迎';

  @override
  String get invalidPopularity => '请输入有效的热门度';

  @override
  String get addToCart => '加入购物车';

  @override
  String get stockUnknown => '库存未知';

  @override
  String get startChatPrompt => '开始对话';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger（实时）';

  @override
  String get clear => '清除';

  @override
  String get warehouseRole => '仓库';

  @override
  String get carrierRole => '承运商';

  @override
  String get supportRole => '支持';

  @override
  String get orderStatusCreated => '已创建';

  @override
  String get orderStatusPendingPayment => '待付款';

  @override
  String get orderStatusPaid => '已付款';

  @override
  String get orderStatusPaymentFailed => '付款失败';

  @override
  String get orderStatusCancelRequested => '已申请取消';

  @override
  String get orderStatusCancelled => '已取消';

  @override
  String get orderStatusOrderConfirmed => '已确认';

  @override
  String get orderStatusStockAllocated => '已分配库存';

  @override
  String get orderStatusBackorder => '缺货待补';

  @override
  String get orderStatusPicking => '拣货中';

  @override
  String get orderStatusPacked => '已打包';

  @override
  String get orderStatusReadyToShip => '待发货';

  @override
  String get orderStatusPartiallyShipped => '部分已发货';

  @override
  String get orderStatusShipped => '已发货';

  @override
  String get orderStatusPartiallyDelivered => '部分已送达';

  @override
  String get orderStatusDelivered => '已送达';

  @override
  String get orderStatusDeliveryFailed => '配送失败';

  @override
  String get orderStatusException => '异常';

  @override
  String get orderStatusReturnRequested => '已申请退货';

  @override
  String get orderStatusReturnInTransit => '退货中';

  @override
  String get orderStatusReturnReceived => '已收退货';

  @override
  String get orderStatusRefundPending => '待退款';

  @override
  String get orderStatusRefunded => '已退款';

  @override
  String get orderStatusClosed => '已关闭';

  @override
  String get shipmentStatusLabelCreated => '已创建标签';

  @override
  String get shipmentStatusPickedUp => '已揽收';

  @override
  String get shipmentStatusInTransit => '运输中';

  @override
  String get shipmentStatusArrivedAtHub => '已到达分拨中心';

  @override
  String get shipmentStatusCustomsClearance => '清关';

  @override
  String get shipmentStatusOutForDelivery => '派送中';

  @override
  String get shipmentStatusDelivered => '已送达';

  @override
  String get shipmentStatusDeliveryFailed => '派送失败';

  @override
  String get shipmentStatusException => '异常';

  @override
  String get shipmentStatusLost => '丢失';

  @override
  String get shipmentStatusDamaged => '破损';

  @override
  String get shipmentStatusReturnToSender => '退回发件人';

  @override
  String get returnStatusRequested => '已申请';

  @override
  String get returnStatusAuthorized => '已授权';

  @override
  String get returnStatusLabelIssued => '已发放标签';

  @override
  String get returnStatusInTransit => '运输中';

  @override
  String get returnStatusReceived => '已收到';

  @override
  String get returnStatusRejected => '已拒绝';

  @override
  String get returnStatusRefundPending => '待退款';

  @override
  String get returnStatusRefunded => '已退款';

  @override
  String get paymentStatusPending => '待处理';

  @override
  String get paymentStatusAuthorized => '已授权';

  @override
  String get paymentStatusCaptured => '已扣款';

  @override
  String get paymentStatusVoided => '已作废';

  @override
  String get paymentStatusRefunded => '已退款';

  @override
  String get paymentStatusFailed => '失败';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => '畅销';

  @override
  String get readMore => '阅读更多';

  @override
  String get showLess => '收起';
}
