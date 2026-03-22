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
  String get messengerDashboard => 'Sigma Messenger Dashboard';

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
  String get supportChatPlaceholder => 'Message to support...';

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
