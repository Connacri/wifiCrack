// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'ホーム';

  @override
  String get map => 'マップ';

  @override
  String get scan => 'スキャン';

  @override
  String get settings => '設定';

  @override
  String get admin => '管理者';

  @override
  String get commerce => 'コマース';

  @override
  String get p2pChat => 'P2Pチャット';

  @override
  String get publishAd => '広告を掲載する';

  @override
  String get connect => '接続';

  @override
  String get disconnect => '切断';

  @override
  String get copy => 'コピー';

  @override
  String get share => '共有';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get save => '保存';

  @override
  String get search => '検索';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get password => 'パスワード';

  @override
  String get pseudo => 'ニックネーム';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get system => 'システム';

  @override
  String get about => 'このアプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get profileTooltip => 'プロフィール';

  @override
  String get adminTooltip => '管理者';

  @override
  String get chatTooltip => 'チャット';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'WiFiをスキャン';

  @override
  String get scanning => 'スキャン中...';

  @override
  String get noNetworks => 'ネットワークが見つかりません';

  @override
  String get permissionDenied => '権限が拒否されました';

  @override
  String get fixPermissions => '権限を修正する';

  @override
  String get detected => '検出済み';

  @override
  String get connected => '接続済み';

  @override
  String get failed => '失敗';

  @override
  String get coins => 'コイン';

  @override
  String get publishAdEarn => '広告を掲載して稼ぐ';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => '管理者からログアウトしました。';

  @override
  String get logoutTooltip => 'ローカルログアウト';

  @override
  String get tabStats => '統計';

  @override
  String get tabAds => '広告';

  @override
  String get tabTargets => 'ターゲット';

  @override
  String get tabMap => 'マップ';

  @override
  String get tabTraces => 'トレース';

  @override
  String get tabContacts => '連絡先';

  @override
  String get tabConfig => '設定';

  @override
  String get securityAdmin => '🔐 管理者セキュリティ';

  @override
  String get changePasswordInfo =>
      'ダッシュボードのアクセスパスワードを変更します。この変更はすべてのデバイスに即座に適用されます。';

  @override
  String get minPasswordError => 'パスワードは6文字以上である必要があります。';

  @override
  String get passwordUpdateSuccess => '✅ Supabaseの管理者パスワードが更新されました！';

  @override
  String get passwordUpdateError => '❌ 更新中にエラーが発生しました。';

  @override
  String get addCarousel => '📢 カルーセルに追加';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get publish => '公開';

  @override
  String get bannerAdded => 'バナーが追加されました！';

  @override
  String get userSubmissionsManagement => 'ユーザー投稿管理';

  @override
  String get unknown => '不明';

  @override
  String get model => 'モデル';

  @override
  String get coinsLabel => 'コイン';

  @override
  String get chat => 'チャット';

  @override
  String get giveCoins => 'コインをあげる';

  @override
  String get coinsAmountLabel => 'コインの数';

  @override
  String get add => '追加';

  @override
  String get online => 'オンライン';

  @override
  String get offline => 'オフライン';

  @override
  String get searchPlaceholder => '検索...';

  @override
  String get bannerText => 'バナーテキスト';

  @override
  String get imageUrl => '画像URL';

  @override
  String get externalLink => '外部リンク';

  @override
  String get editPseudo => 'ニックネームを編集';

  @override
  String get newPseudo => '新しいニックネーム';

  @override
  String get pseudoUpdated => 'ニックネームが更新されました！';

  @override
  String get pseudoError => 'ニックネームが使用できないか、エラーが発生しました。';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'ユーザーが見つかりません。';

  @override
  String get noActivityAvailable => '利用可能なアクティビティはありません。';

  @override
  String get deleteConversation => '会話を削除';

  @override
  String confirmDeleteConversation(String pseudo) {
    return '$pseudoとのすべてのメッセージを削除しますか？';
  }

  @override
  String get conversationDeleted => '会話がローカルで削除されました。';

  @override
  String get p2pSecure => 'セキュアP2P';

  @override
  String coinsForUser(String pseudo) {
    return '$pseudoへのコイン';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$pseudoに$amountコインが追加されました';
  }

  @override
  String get amountLabel => '金額';

  @override
  String get addCoins => 'コインを追加';

  @override
  String get refreshUsers => 'ユーザーを更新';

  @override
  String get changePseudoTooltip => 'ニックネームを変更';

  @override
  String get userProfile => 'プロフィール';

  @override
  String p2pSecureSubtitle(String id) {
    return 'セキュアP2P • $id...';
  }

  @override
  String get deleteConversationTooltip => '会話を削除';

  @override
  String get addCoinsTooltip => 'コインをあげる';

  @override
  String get coinsToAddLabel => '追加するコインの数';

  @override
  String get messageSigmaPlaceholder => 'Sigmaメッセージ...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'ユーザープロフィール';

  @override
  String get tabInfo => '情報';

  @override
  String get tabActivity => 'アクティビティ';

  @override
  String get tabSecurity => 'セキュリティ';

  @override
  String get tabNetwork => 'ネットワーク';

  @override
  String get identity => '身元';

  @override
  String get deviceAndSession => 'デバイスとセッション';

  @override
  String get lastActivity => '最終アクティビティ';

  @override
  String get createdAt => '作成日';

  @override
  String get activitySummary => 'アクティビティ概要';

  @override
  String get eventsCollected => '収集されたイベント';

  @override
  String get validGpsPoints => '有効なGPSポイント';

  @override
  String get maxContactsSeen => '最大接触数';

  @override
  String get securityStatus => 'セキュリティステータス';

  @override
  String get activeSession => 'アクティブなセッション';

  @override
  String get lastPing => '最終確認';

  @override
  String agoMin(int minutes) {
    return '$minutes分前';
  }

  @override
  String get anomalyDetected => '異常が検出されました';

  @override
  String get none => 'なし（ローカルヒューリスティック）';

  @override
  String get securityNote =>
      '注：このタブは利用可能なデータに基づいたアプリケーションセキュリティシグナルを表示します（完全なサーバー監査ではありません）。';

  @override
  String get networkStatus => 'ネットワークステータス';

  @override
  String get mainChannel => 'メインチャネル';

  @override
  String get presence => 'プレゼンス';

  @override
  String get available => '利用可能';

  @override
  String get unavailable => '利用不可';

  @override
  String get geolocSamples => '位置情報サンプル';

  @override
  String get rawDebugData => '生デバッグデータ';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get sigmaAdProposalTitle => '🚀 Sigma広告を提案する';

  @override
  String get submitAdSuccess => '✅ 投稿が送信されました！コインを受け取るには管理者の承認をお待ちください。';

  @override
  String get submitAdInfo => '画像と説明を送信してコインを稼ぎましょう！';

  @override
  String get descriptionLabel => '説明';

  @override
  String get submit => '送信';

  @override
  String get bonusActivated => 'コインボーナスが有効になりました！（ビデオ視聴済み）';

  @override
  String get watchVideoBonus => 'ビデオを見て+50ボーナスコインを獲得';

  @override
  String get languageSelectorTitle => 'Select Language / 言語を選択';

  @override
  String get imageLinkUrl => '画像リンク (URL)';

  @override
  String get bonusAddedText => 'コインボーナスが有効になりました！（ビデオ視聴済み）';

  @override
  String get close => '閉じる';

  @override
  String copiedToClipboard(String text) {
    return 'キーをコピーしました: $text';
  }

  @override
  String get disconnectTooltip => '切断';

  @override
  String get connectTooltip => '計算して接続';

  @override
  String get audioUnavailable => '音声は利用できません。';

  @override
  String get supportSigmaPro => 'Sigma Pro サポート';

  @override
  String get p2pEncryptedChat => '暗号化されたP2Pメッセージング';

  @override
  String get needHelpMessage => 'ヘルプが必要ですか？メッセージを送ってください。';

  @override
  String get chooseAdminRole => '管理者の役割を選択してください';

  @override
  String get configRequiredTitle => '必要な設定';

  @override
  String get configRequiredInfo => 'Sigmaを動作させるには、以下が必要です： \n';

  @override
  String get configVisibleNote => 'これがないと、Sigmaマップ上に表示されません。';

  @override
  String get configureNow => '今すぐ設定する';

  @override
  String get accessDenied => 'アクセスが拒否されました。';

  @override
  String sigmaKey(String key) {
    return 'Sigmaキー: $key';
  }

  @override
  String get wifiDisabled => 'WiFiが無効です。';

  @override
  String get locationWifiPermsRequired => '位置情報とWiFiの権限が必要です。';

  @override
  String get gpsRequiredAndroid => 'AndroidでのスキャンにはGPSが必要です。';

  @override
  String get noCompatibleNetworks => '近くに互換性のあるネットワークが見つかりませんでした。';

  @override
  String scanError(String error) {
    return 'スキャンエラー: $error';
  }

  @override
  String get scanNotSupported => 'このデバイスではWiFiスキャンがサポートされていません。';

  @override
  String get gpsDisabled => 'GPSが無効です。';

  @override
  String scanUnavailable(String status) {
    return 'スキャンは利用できません ($status)。';
  }

  @override
  String get manualKeyEntryNote => '接続に失敗した場合は、キーを手動で入力してください。';

  @override
  String get authRequired => '認証が必要です';

  @override
  String get chooseRole => '役割を選択してください';

  @override
  String get user => 'ユーザー';

  @override
  String get validate => '検証';

  @override
  String get authTitle => '認証';

  @override
  String get commerceLogin => 'コマースログイン';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get email => 'メールアドレス';

  @override
  String get forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get loginGoogle => 'Googleで続行';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？登録';

  @override
  String get hasAccount => '既にアカウントをお持ちですか？ログイン';

  @override
  String get resetEmailSent => 'リセットメールを送信しました！';

  @override
  String get fillAllFields => 'すべての項目を入力してください。';

  @override
  String googleError(String error) {
    return 'Googleエラー: $error';
  }

  @override
  String get permsRequiredTitle => '必要な権限';

  @override
  String get permsRequiredInfo => 'このアプリを使用するには、必ず以下を行う必要があります：\n\n';

  @override
  String get permsFatalNote => 'これがないと、アプリは動作しません。';

  @override
  String get understandAndConfigure => '了解しました、設定する';

  @override
  String get commerceDisconnectConfirm => 'コマースからログアウトしますか？';

  @override
  String get startDiscussion => 'ディスカッションを開始';

  @override
  String get yourMessage => 'メッセージを入力...';

  @override
  String get orderErrorUnidentified => '注文できません：ユーザーが特定されていません。';

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
