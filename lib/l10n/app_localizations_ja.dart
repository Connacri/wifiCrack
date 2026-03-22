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
  String confirmDeleteConversation(Object pseudo) {
    return '$pseudoとのすべてのメッセージを削除しますか？';
  }

  @override
  String get conversationDeleted => '会話がローカルで削除されました。';

  @override
  String get p2pSecure => 'セキュアP2P';

  @override
  String coinsForUser(Object pseudo) {
    return '$pseudoへのコイン';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'スキャンエラー: $error';
  }

  @override
  String get scanNotSupported => 'このデバイスではWiFiスキャンがサポートされていません。';

  @override
  String get gpsDisabled => 'GPSが無効です。';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
