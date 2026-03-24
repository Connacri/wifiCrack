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
  String get messengerDashboard => 'Sigma Messenger ???????';

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
  String get supportChatPlaceholder => '???????????...';

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
  String get client => '??';

  @override
  String get vendor => '???';

  @override
  String get deliveryPerson => '???';

  @override
  String get wholesaler => '????';

  @override
  String get vocalSigma => 'Sigma ???';

  @override
  String get defaultMessageContent => '?????';

  @override
  String get myContacts => '???';

  @override
  String get myQrCodeTooltip => '???QR???';

  @override
  String get scanFriendTooltip => '???????';

  @override
  String get friendAddedSuccess => '? ???????????';

  @override
  String get editPseudoMenu => '?????????';

  @override
  String get myPseudoTitle => '?????????';

  @override
  String get enterPseudoHint => '?????????';

  @override
  String get noContacts => '?????????';

  @override
  String get scanFriendToStart => '???QR????????????';

  @override
  String get scanFriendButton => '???????';

  @override
  String get addedOn => '???';

  @override
  String get scanQrCodeTitle => 'QR????????';

  @override
  String get qrCodeUnreadable => 'QR????????????????????????';

  @override
  String get invalidMistralQr => '??QR????Mistral P2P???????????';

  @override
  String invalidLinkError(String error) {
    return '??????: $error';
  }

  @override
  String get cannotAddSelf => '?? ???????????';

  @override
  String get friendAlreadyAdded => '?? ????????????????';

  @override
  String get placeQrInFrame => 'QR???????????????';

  @override
  String get retry => '???';

  @override
  String get flashlightTooltip => '???';

  @override
  String get shareLinkTooltip => '??????';

  @override
  String inviteText(String link) {
    return 'Mistral2laude P2P?????????\n$link';
  }

  @override
  String get inviteSubject => 'Mistral2laude P2P ??';

  @override
  String get scanMeText => '??QR??????????\n????????????';

  @override
  String get microphonePermissionDenied => '??????????????';

  @override
  String get connectionNotEstablished => '?? ????????????????????????????????';

  @override
  String get noMessagesYet => '????????????\n????????????????? ??';

  @override
  String get statusConnected => '????';

  @override
  String get statusConnecting => '???...';

  @override
  String get statusFailed => '??';

  @override
  String get statusOffline => '?????';

  @override
  String get recordingHint => '?? ???...';

  @override
  String get messageHint => '?????...';

  @override
  String get connectingHint => '???...';

  @override
  String get initFailed => '??????????';

  @override
  String get defaultUserPseudo => 'M2C????';

  @override
  String get mobileDevice => '??????';

  @override
  String get unknownDevice => '?????';

  @override
  String get productsTab => '??';

  @override
  String get ordersTab => '??';

  @override
  String get cartTab => '???';

  @override
  String get clientModeTooltip => '?????';

  @override
  String get adminModeTooltip => '??????';

  @override
  String get addProductTooltip => '?????';

  @override
  String get orderCreated => '???????????';

  @override
  String get orderFailed => '??????????';

  @override
  String get productCreated => '???????????';

  @override
  String get productUpdated => '???????????';

  @override
  String get productDeleted => '???????????';

  @override
  String get deleteFailed => '??????????';

  @override
  String get deleteProductTitle => '?????';

  @override
  String deleteProductConfirm(String name) {
    return '?$name?????????';
  }

  @override
  String get imageUploaded => '??????????????';

  @override
  String imageUploadFailed(String error) {
    return '????????????????: $error';
  }

  @override
  String get supabaseBucketNotConfigured => 'Supabase ??????????????????';

  @override
  String get searchProductsPlaceholder => '?????SKU???';

  @override
  String get inStockFilter => '????';

  @override
  String get includeInactiveFilter => '??????????';

  @override
  String get sortName => '??';

  @override
  String get sortPriceAsc => '???????';

  @override
  String get sortPriceDesc => '???????';

  @override
  String get sortStockAsc => '????????';

  @override
  String get sortStockDesc => '???????';

  @override
  String get sortPopularity => '??';

  @override
  String get gridView => '????';

  @override
  String get listView => '???';

  @override
  String get noProductsMatch => '???????????????????';

  @override
  String get clearFilters => '?????????';

  @override
  String get allProductsLoaded => '???????????????';

  @override
  String get saveProductTitle => '?????';

  @override
  String get addProductTitle => '?????';

  @override
  String get editProductTitle => '?????';

  @override
  String get productNameLabel => '??';

  @override
  String get skuLabel => 'SKU / ??';

  @override
  String get priceLabel => '?? (DZD)';

  @override
  String get promoPriceLabel => '????? (DZD)';

  @override
  String get optionalHelper => '??';

  @override
  String get imageLabel => '??URL??????????';

  @override
  String get uploadImageButton => '?????????';

  @override
  String get replaceImageButton => '?????';

  @override
  String get uploadingButton => '???????...';

  @override
  String get stockLabel => '??';

  @override
  String get popularityLabel => '??';

  @override
  String get activeLabel => '??';

  @override
  String get saveButton => '??';

  @override
  String get savingButton => '???...';

  @override
  String get unavailableStatus => '????';

  @override
  String get outOfStockStatus => '????';

  @override
  String get lowStockStatus => '???';

  @override
  String get inactiveStatus => '??';

  @override
  String get promoStatus => '???';

  @override
  String get cartEmpty => '????????';

  @override
  String get yourCart => '???????';

  @override
  String get clearCart => '???';

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
  String get checkoutButton => '???????';

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
  String get changeRoleTooltip => '???????????????';

  @override
  String get orderNotFound => '??????????';

  @override
  String get globalStatus => '???????';

  @override
  String get dateLabel => '??';

  @override
  String get customerLabel => '??';

  @override
  String get paymentLabel => '???';

  @override
  String get productsLabel => '??';

  @override
  String priceXQuantity(String price, int quantity) {
    return '??: $price DZD x $quantity';
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
  String get noShipmentsYet => '???????????';

  @override
  String shipmentsCount(int count) {
    return '?? ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return '??: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return '????: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => '???';

  @override
  String get itemsInPackage => '???????:';

  @override
  String get confirmOrderButton => '?????';

  @override
  String get allocateStockButton => '???????';

  @override
  String get startPickingButton => '???????';

  @override
  String get packingFinishedButton => '??????????';

  @override
  String get shipButton => '????????';

  @override
  String setInTransitButton(String tracking) {
    return '???????$tracking?';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return '??????$tracking?';
  }

  @override
  String get requestReturnButton => '?????';

  @override
  String get newShipmentTitle => '?????';

  @override
  String get allItemIncludedNote => '???????????????????????';

  @override
  String get trackingNumberLabel => '????';

  @override
  String get adminStatusTitle => '?? : ?????';

  @override
  String get phoneAddressRequired => '?????????????';

  @override
  String get orderFailedLong => '??????????';

  @override
  String orderCreatedLong(String id) {
    return '??????????: $id';
  }

  @override
  String get placingOrderButton => '???...';

  @override
  String get placeOrderButton => '????';

  @override
  String get loadMoreButton => '???????';

  @override
  String get searchOrderPlaceholder => '?????...';

  @override
  String get allFilter => '???';

  @override
  String get orderConfirmedStep => '????';

  @override
  String get shippedStep => '????';

  @override
  String get deliveredStep => '????';

  @override
  String get unknownDate => '??';

  @override
  String get p2pMessengerTitle => 'P2P???????';

  @override
  String errorWithDetails(String message) {
    return '???: $message';
  }

  @override
  String get myQrCode => '???QR???';

  @override
  String get shareQrCodeTitle => 'QR??????';

  @override
  String get shareQrCodeSubtitle => '???????????????????????????????????';

  @override
  String get takeScreenshotToShare => 'QR?????????????????????????????';

  @override
  String get initErrorTitle => '??????';

  @override
  String get messagesTitle => '?????';

  @override
  String get addContactTooltip => '??????';

  @override
  String get noConversations => '??????????';

  @override
  String get addContactToStart => '???????????????';

  @override
  String get typingStatus => '???...';

  @override
  String get sayHello => '?????? ??';

  @override
  String get yesterday => '??';

  @override
  String get addFriendTitle => '?????';

  @override
  String get scanFriendQr => '???QR????????';

  @override
  String get addContactTitle => '??????';

  @override
  String get yourQrCodeTitle => '????QR???';

  @override
  String get yourQrCodeSubtitle => '????????????????';

  @override
  String get notAvailable => '????';

  @override
  String get deviceIdLabel => 'デバイスID';

  @override
  String get contactAddedSuccess => '????????????';

  @override
  String get dataChannelDisconnected => '???????????????';

  @override
  String peerNotConnected(String id) {
    return '????????????: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return '??????????: $error';
  }

  @override
  String invalidQrCode(String error) {
    return '???QR???: $error';
  }

  @override
  String get missingDeviceId => 'デバイスIDがありません';

  @override
  String get missingPseudo => '????????????';

  @override
  String get missingPublicKey => '?????????';

  @override
  String get cannotAddSelfError => '??????????';

  @override
  String get invalidPublicKeyFormat => '???????????';

  @override
  String errorParsingQrCode(String error) {
    return 'QR????????: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => '??';

  @override
  String get encryptedMessage => '[????????]';

  @override
  String get youEncryptedMessage => '???: [????????]';

  @override
  String get imageMessage => '??? ??';

  @override
  String get fileMessage => '?? ????';

  @override
  String get newMessage => '????????';

  @override
  String get reply => '??';

  @override
  String get quickReply => '??????';

  @override
  String get markAsRead => '?????';

  @override
  String get isTyping => '???...';

  @override
  String get typingIndicator => '???...';

  @override
  String get vocalMessage => '????????';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => '??';

  @override
  String get trace => '????';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'フォームのエラーを修正してください。';

  @override
  String get saveFailed => '保存に失敗しました。';

  @override
  String get itemsLabel => 'アイテム';

  @override
  String get productInfoSection => '情報';

  @override
  String get productImageSection => '画像';

  @override
  String get productStockStatusSection => '在庫とステータス';

  @override
  String get categoryLabel => 'カテゴリ';

  @override
  String get nameRequired => '名前は必須です';

  @override
  String get priceRequired => '価格は必須です';

  @override
  String get invalidPrice => '有効な価格を入力してください';

  @override
  String get invalidPromoPrice => '有効なプロモ価格を入力してください';

  @override
  String get promoLowerThanPrice => 'プロモ価格は通常価格より低くする必要があります';

  @override
  String get invalidStock => '有効な在庫数を入力してください';

  @override
  String get popularityHelper => '数値が高いほど人気';

  @override
  String get invalidPopularity => '有効な人気度を入力してください';

  @override
  String get addToCart => 'カートに追加';

  @override
  String get stockUnknown => '在庫不明';

  @override
  String get startChatPrompt => '会話を始めましょう';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger（リアルタイム）';

  @override
  String get clear => 'クリア';

  @override
  String get warehouseRole => '倉庫';

  @override
  String get carrierRole => '運送業者';

  @override
  String get supportRole => 'サポート';

  @override
  String get orderStatusCreated => '作成済み';

  @override
  String get orderStatusPendingPayment => '支払い待ち';

  @override
  String get orderStatusPaid => '支払い済み';

  @override
  String get orderStatusPaymentFailed => '支払い失敗';

  @override
  String get orderStatusCancelRequested => 'キャンセル申請';

  @override
  String get orderStatusCancelled => 'キャンセル済み';

  @override
  String get orderStatusOrderConfirmed => '確認済み';

  @override
  String get orderStatusStockAllocated => '在庫割当済み';

  @override
  String get orderStatusBackorder => 'バックオーダー';

  @override
  String get orderStatusPicking => 'ピッキング中';

  @override
  String get orderStatusPacked => '梱包済み';

  @override
  String get orderStatusReadyToShip => '出荷準備完了';

  @override
  String get orderStatusPartiallyShipped => '一部出荷';

  @override
  String get orderStatusShipped => '出荷済み';

  @override
  String get orderStatusPartiallyDelivered => '一部配送完了';

  @override
  String get orderStatusDelivered => '配送完了';

  @override
  String get orderStatusDeliveryFailed => '配送失敗';

  @override
  String get orderStatusException => '例外';

  @override
  String get orderStatusReturnRequested => '返品申請';

  @override
  String get orderStatusReturnInTransit => '返品配送中';

  @override
  String get orderStatusReturnReceived => '返品受領';

  @override
  String get orderStatusRefundPending => '返金処理中';

  @override
  String get orderStatusRefunded => '返金済み';

  @override
  String get orderStatusClosed => '完了';

  @override
  String get shipmentStatusLabelCreated => 'ラベル作成';

  @override
  String get shipmentStatusPickedUp => '集荷済み';

  @override
  String get shipmentStatusInTransit => '輸送中';

  @override
  String get shipmentStatusArrivedAtHub => 'ハブ到着';

  @override
  String get shipmentStatusCustomsClearance => '通関';

  @override
  String get shipmentStatusOutForDelivery => '配達中';

  @override
  String get shipmentStatusDelivered => '配達済み';

  @override
  String get shipmentStatusDeliveryFailed => '配達失敗';

  @override
  String get shipmentStatusException => '例外';

  @override
  String get shipmentStatusLost => '紛失';

  @override
  String get shipmentStatusDamaged => '破損';

  @override
  String get shipmentStatusReturnToSender => '差出人へ返送';

  @override
  String get returnStatusRequested => '申請済み';

  @override
  String get returnStatusAuthorized => '承認済み';

  @override
  String get returnStatusLabelIssued => 'ラベル発行';

  @override
  String get returnStatusInTransit => '輸送中';

  @override
  String get returnStatusReceived => '受領済み';

  @override
  String get returnStatusRejected => '却下';

  @override
  String get returnStatusRefundPending => '返金処理中';

  @override
  String get returnStatusRefunded => '返金済み';

  @override
  String get paymentStatusPending => '保留中';

  @override
  String get paymentStatusAuthorized => '承認済み';

  @override
  String get paymentStatusCaptured => '確定';

  @override
  String get paymentStatusVoided => '取消済み';

  @override
  String get paymentStatusRefunded => '返金済み';

  @override
  String get paymentStatusFailed => '失敗';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'ベストセラー';

  @override
  String get readMore => '続きを読む';

  @override
  String get showLess => '閉じる';
}
