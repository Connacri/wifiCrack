// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Beranda';

  @override
  String get map => 'Peta';

  @override
  String get scan => 'Pindai';

  @override
  String get settings => 'Pengaturan';

  @override
  String get admin => 'Admin';

  @override
  String get commerce => 'Perdagangan';

  @override
  String get p2pChat => 'Obrolan P2P';

  @override
  String get publishAd => 'Pasang iklan';

  @override
  String get connect => 'Hubungkan';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get copy => 'Salin';

  @override
  String get share => 'Bagikan';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get delete => 'Hapus';

  @override
  String get edit => 'Ubah';

  @override
  String get save => 'Simpan';

  @override
  String get search => 'Cari';

  @override
  String get loading => 'Memuat...';

  @override
  String get error => 'Kesalahan';

  @override
  String get success => 'Berhasil';

  @override
  String get password => 'Kata sandi';

  @override
  String get pseudo => 'Nama samaran';

  @override
  String get login => 'Masuk';

  @override
  String get logout => 'Keluar';

  @override
  String get language => 'Bahasa';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Terang';

  @override
  String get dark => 'Gelap';

  @override
  String get system => 'Sistem';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get profileTooltip => 'Profil';

  @override
  String get adminTooltip => 'Admin';

  @override
  String get chatTooltip => 'Obrolan';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'Pindai WiFi';

  @override
  String get scanning => 'Memindai...';

  @override
  String get noNetworks => 'Tidak ada jaringan ditemukan';

  @override
  String get permissionDenied => 'Izin ditolak';

  @override
  String get fixPermissions => 'Perbaiki izin';

  @override
  String get detected => 'Terdeteksi';

  @override
  String get connected => 'Terhubung';

  @override
  String get failed => 'Gagal';

  @override
  String get coins => 'Koin';

  @override
  String get publishAdEarn => 'Pasang iklan & dapatkan koin';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Terputus dari admin.';

  @override
  String get logoutTooltip => 'Keluar Lokal';

  @override
  String get tabStats => 'Statistik';

  @override
  String get tabAds => 'Iklan';

  @override
  String get tabTargets => 'Target';

  @override
  String get tabMap => 'Peta';

  @override
  String get tabTraces => 'Jejak';

  @override
  String get tabContacts => 'Kontak';

  @override
  String get tabConfig => 'Konfigurasi';

  @override
  String get securityAdmin => '🔐 Keamanan Admin';

  @override
  String get changePasswordInfo =>
      'Ubah kata sandi akses dashboard. Perubahan ini segera berlaku untuk semua perangkat.';

  @override
  String get minPasswordError => 'Kata sandi minimal harus 6 karakter.';

  @override
  String get passwordUpdateSuccess =>
      '✅ Kata sandi Admin diperbarui di Supabase!';

  @override
  String get passwordUpdateError => '❌ Kesalahan saat memperbarui.';

  @override
  String get addCarousel => '📢 Tambah ke Karusel';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get newPassword => 'Kata sandi baru';

  @override
  String get publish => 'Publikasikan';

  @override
  String get bannerAdded => 'Spanduk ditambahkan!';

  @override
  String get userSubmissionsManagement => 'Manajemen pengajuan pengguna';

  @override
  String get unknown => 'Tidak dikenal';

  @override
  String get model => 'Model';

  @override
  String get coinsLabel => 'Koin';

  @override
  String get chat => 'Obrolan';

  @override
  String get giveCoins => 'Beri Koin';

  @override
  String get coinsAmountLabel => 'Jumlah koin';

  @override
  String get add => 'Tambah';

  @override
  String get online => 'Daring';

  @override
  String get offline => 'Luring';

  @override
  String get searchPlaceholder => 'Cari...';

  @override
  String get bannerText => 'Teks spanduk';

  @override
  String get imageUrl => 'URL gambar';

  @override
  String get externalLink => 'Tautan eksternal';

  @override
  String get editPseudo => 'Ubah Nama Samaran saya';

  @override
  String get newPseudo => 'Nama Samaran Baru';

  @override
  String get pseudoUpdated => 'Nama samaran diperbarui!';

  @override
  String get pseudoError => 'Nama samaran tidak tersedia atau kesalahan.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'Tidak ada pengguna ditemukan.';

  @override
  String get noActivityAvailable => 'Tidak ada aktivitas yang tersedia.';

  @override
  String get deleteConversation => 'Hapus obrolan';

  @override
  String confirmDeleteConversation(String pseudo) {
    return 'Hapus semua pesan dengan $pseudo?';
  }

  @override
  String get conversationDeleted => 'Obrolan dihapus secara lokal.';

  @override
  String get p2pSecure => 'P2P Aman';

  @override
  String coinsForUser(String pseudo) {
    return 'Koin untuk $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$amount koin ditambahkan ke $pseudo';
  }

  @override
  String get amountLabel => 'Jumlah';

  @override
  String get addCoins => 'Tambah Koin';

  @override
  String get refreshUsers => 'Segarkan pengguna';

  @override
  String get changePseudoTooltip => 'Ubah nama samaran saya';

  @override
  String get userProfile => 'Profil';

  @override
  String p2pSecureSubtitle(String id) {
    return 'P2P Aman • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Hapus obrolan';

  @override
  String get addCoinsTooltip => 'Beri koin';

  @override
  String get coinsToAddLabel => 'Jumlah koin yang akan ditambah';

  @override
  String get messageSigmaPlaceholder => 'Pesan Sigma...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'Profil pengguna';

  @override
  String get tabInfo => 'Info';

  @override
  String get tabActivity => 'Aktivitas';

  @override
  String get tabSecurity => 'Keamanan';

  @override
  String get tabNetwork => 'Jaringan';

  @override
  String get identity => 'Identitas';

  @override
  String get deviceAndSession => 'Perangkat & Sesi';

  @override
  String get lastActivity => 'Aktivitas terakhir';

  @override
  String get createdAt => 'Dibuat pada';

  @override
  String get activitySummary => 'Ringkasan aktivitas';

  @override
  String get eventsCollected => 'Acara dikumpulkan';

  @override
  String get validGpsPoints => 'Titik GPS valid';

  @override
  String get maxContactsSeen => 'Kontak maksimal terlihat';

  @override
  String get securityStatus => 'Status keamanan';

  @override
  String get activeSession => 'Sesi aktif';

  @override
  String get lastPing => 'Ping terakhir';

  @override
  String agoMin(int minutes) {
    return '$minutes menit yang lalu';
  }

  @override
  String get anomalyDetected => 'Anomali terdeteksi';

  @override
  String get none => 'Tidak ada (heuristik lokal)';

  @override
  String get securityNote =>
      'Catatan: tab ini menampilkan sinyal keamanan aplikasi berdasarkan data yang tersedia (bukan audit server lengkap).';

  @override
  String get networkStatus => 'Status jaringan';

  @override
  String get mainChannel => 'Saluran utama';

  @override
  String get presence => 'Kehadiran';

  @override
  String get available => 'Tersedia';

  @override
  String get unavailable => 'Tidak tersedia';

  @override
  String get geolocSamples => 'Sampel geolokasi';

  @override
  String get rawDebugData => 'Data mentah (debug)';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get sigmaAdProposalTitle => '🚀 Ajukan iklan Sigma Anda';

  @override
  String get submitAdSuccess =>
      '✅ Pengajuan terkirim! Tunggu validasi admin untuk koin Anda.';

  @override
  String get submitAdInfo => 'Kirim gambar, deskripsi, dan dapatkan koin!';

  @override
  String get descriptionLabel => 'Deskripsi';

  @override
  String get submit => 'Kirim';

  @override
  String get bonusActivated => 'Bonus Koin diaktifkan! (Video ditonton)';

  @override
  String get watchVideoBonus => 'Tonton video untuk +50 koin bonus';

  @override
  String get languageSelectorTitle => 'Select Language / Pilih bahasa';

  @override
  String get imageLinkUrl => 'Tautan gambar (URL)';

  @override
  String get bonusAddedText => 'Bonus Koin diaktifkan! (Video ditonton)';

  @override
  String get close => 'Tutup';

  @override
  String copiedToClipboard(String text) {
    return 'Kunci disalin: $text';
  }

  @override
  String get disconnectTooltip => 'Putuskan';

  @override
  String get connectTooltip => 'Hitung & Hubungkan';

  @override
  String get audioUnavailable => 'Suara tidak tersedia.';

  @override
  String get supportSigmaPro => 'Dukungan Sigma Pro';

  @override
  String get p2pEncryptedChat => 'Pesan P2P Terenkripsi';

  @override
  String get needHelpMessage => 'Butuh bantuan? Kirimkan pesan kepada kami.';

  @override
  String get chooseAdminRole => 'Pilih peran Admin Anda';

  @override
  String get configRequiredTitle => 'Konfigurasi Diperlukan';

  @override
  String get configRequiredInfo => 'Untuk berfungsi, Sigma membutuhkan: \n';

  @override
  String get configVisibleNote =>
      'Tanpa ini, Anda tidak akan terlihat di peta Sigma.';

  @override
  String get configureNow => 'Konfigurasi Sekarang';

  @override
  String get accessDenied => 'Akses ditolak.';

  @override
  String sigmaKey(String key) {
    return 'Kunci Sigma: $key';
  }

  @override
  String get wifiDisabled => 'WiFi dinonaktifkan.';

  @override
  String get locationWifiPermsRequired => 'Izin lokasi/WiFi diperlukan.';

  @override
  String get gpsRequiredAndroid => 'GPS diperlukan untuk memindai di Android.';

  @override
  String get noCompatibleNetworks =>
      'Tidak ada jaringan kompatibel yang terdeteksi di sekitar.';

  @override
  String scanError(String error) {
    return 'Kesalahan pemindaian: $error';
  }

  @override
  String get scanNotSupported =>
      'Pemindaian WiFi tidak didukung pada perangkat ini.';

  @override
  String get gpsDisabled => 'GPS dinonaktifkan.';

  @override
  String scanUnavailable(String status) {
    return 'Pemindaian tidak tersedia ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Harap masukkan kunci secara manual jika koneksi gagal.';

  @override
  String get authRequired => 'Autentikasi diperlukan';

  @override
  String get chooseRole => 'Pilih peran Anda';

  @override
  String get user => 'Pengguna';

  @override
  String get validate => 'Validasi';

  @override
  String get authTitle => 'Autentikasi';

  @override
  String get commerceLogin => 'Login Perdagangan';

  @override
  String get createAccount => 'Buat akun';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get loginGoogle => 'Lanjutkan dengan Google';

  @override
  String get noAccount => 'Tidak punya akun? Daftar';

  @override
  String get hasAccount => 'Sudah punya akun? Login';

  @override
  String get resetEmailSent => 'Email reset terkirim!';

  @override
  String get fillAllFields => 'Harap isi semua bidang.';

  @override
  String googleError(String error) {
    return 'Kesalahan Google: $error';
  }

  @override
  String get permsRequiredTitle => 'Izin Diperlukan';

  @override
  String get permsRequiredInfo =>
      'Untuk menggunakan aplikasi ini, Anda harus:\n\n';

  @override
  String get permsFatalNote => 'Tanpa ini, aplikasi tidak dapat berfungsi.';

  @override
  String get understandAndConfigure => 'Saya mengerti, konfigurasi';

  @override
  String get commerceDisconnectConfirm =>
      'Apakah Anda ingin keluar dari perdagangan?';

  @override
  String get startDiscussion => 'Mulai diskusi';

  @override
  String get yourMessage => 'Pesan Anda...';

  @override
  String get orderErrorUnidentified =>
      'Tidak dapat melakukan pemesanan: pengguna tidak teridentifikasi.';

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
