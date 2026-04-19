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
  String get admin => 'Administrator';

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
  String get adminTooltip => 'Administrator';

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
  String get messengerDashboard => 'Dasbor Sigma Messenger';

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
  String get supportChatPlaceholder => 'Pesan ke dukungan...';

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
  String get email => 'Surel';

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
  String get client => 'Pelanggan';

  @override
  String get vendor => 'Penjual';

  @override
  String get deliveryPerson => 'Kurir';

  @override
  String get wholesaler => 'Grosir';

  @override
  String get vocalSigma => 'Suara Sigma';

  @override
  String get defaultMessageContent => 'Pesan';

  @override
  String get myContacts => 'Kontak saya';

  @override
  String get myQrCodeTooltip => 'QR Code saya';

  @override
  String get scanFriendTooltip => 'Pindai teman';

  @override
  String get friendAddedSuccess => '? Teman berhasil ditambahkan!';

  @override
  String get editPseudoMenu => 'Edit nama samaran saya';

  @override
  String get myPseudoTitle => 'Nama samaran saya';

  @override
  String get enterPseudoHint => 'Masukkan nama samaran Anda';

  @override
  String get noContacts => 'Tidak ada kontak';

  @override
  String get scanFriendToStart => 'Pindai QR Code teman untuk memulai';

  @override
  String get scanFriendButton => 'Pindai teman';

  @override
  String get addedOn => 'Ditambahkan pada';

  @override
  String get scanQrCodeTitle => 'Pindai QR Code';

  @override
  String get qrCodeUnreadable => 'QR Code tidak terbaca, coba lagi.';

  @override
  String get invalidMistralQr => 'QR Code ini bukan dari Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Tautan tidak valid: $error';
  }

  @override
  String get cannotAddSelf => '?? Anda tidak bisa menambahkan diri sendiri!';

  @override
  String get friendAlreadyAdded => '?? Teman ini sudah ada di kontak Anda.';

  @override
  String get placeQrInFrame => 'Letakkan QR Code di dalam bingkai';

  @override
  String get retry => 'Coba lagi';

  @override
  String get flashlightTooltip => 'Senter';

  @override
  String get shareLinkTooltip => 'Bagikan tautan';

  @override
  String inviteText(String link) {
    return 'Tambahkan saya di Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => 'Undangan Mistral2laude P2P';

  @override
  String get scanMeText =>
      'Pindai QR Code ini\nuntuk menambahkan saya sebagai kontak';

  @override
  String get microphonePermissionDenied => 'Izin mikrofon ditolak';

  @override
  String get connectionNotEstablished =>
      '?? Koneksi belum terhubung. Pesan disimpan secara lokal.';

  @override
  String get noMessagesYet => 'Belum ada pesan.\nKirim yang pertama! ??';

  @override
  String get statusConnected => 'Terhubung';

  @override
  String get statusConnecting => 'Menghubungkan...';

  @override
  String get statusFailed => 'Gagal';

  @override
  String get statusOffline => 'Offline';

  @override
  String get recordingHint => '?? Merekam...';

  @override
  String get messageHint => 'Pesan...';

  @override
  String get connectingHint => 'Menghubungkan...';

  @override
  String get initFailed => 'Inisialisasi gagal';

  @override
  String get defaultUserPseudo => 'Pengguna M2C';

  @override
  String get mobileDevice => 'Perangkat seluler';

  @override
  String get unknownDevice => 'Perangkat tidak dikenal';

  @override
  String get productsTab => 'Produk';

  @override
  String get logisticsTab => 'Logistics';

  @override
  String get ordersTab => 'Pesanan';

  @override
  String get cartTab => 'Keranjang';

  @override
  String get toPickUp => 'To Pick Up';

  @override
  String get toPrepare => 'To Prepare';

  @override
  String get toDeliver => 'To Deliver';

  @override
  String get shippingLabel => 'Shipping Label';

  @override
  String get generateLabel => 'Generate Label';

  @override
  String get scanForPickup => 'Scan for Pickup';

  @override
  String get scanForDelivery => 'Confirm Delivery';

  @override
  String get deliveryInfo => 'Delivery Info';

  @override
  String get trackMore => 'Package Tracking';

  @override
  String get trackingNumber => 'Tracking No.';

  @override
  String get carrier => 'Carrier';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPrepared => 'Prepared';

  @override
  String get orderStatusReady => 'Ready';

  @override
  String get orderStatusShipped => 'Dikirim';

  @override
  String get orderStatusDelivered => 'Diterima';

  @override
  String get clientModeTooltip => 'Mode pelanggan';

  @override
  String get adminModeTooltip => 'Mode admin';

  @override
  String get addProductTooltip => 'Tambah produk';

  @override
  String get orderCreated => 'Pesanan dibuat.';

  @override
  String get orderFailed => 'Pesanan gagal.';

  @override
  String get productCreated => 'Produk dibuat.';

  @override
  String get productUpdated => 'Produk diperbarui.';

  @override
  String get productDeleted => 'Produk dihapus.';

  @override
  String get deleteFailed => 'Gagal menghapus.';

  @override
  String get deleteProductTitle => 'Hapus produk';

  @override
  String deleteProductConfirm(String name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String get imageUploaded => 'Gambar diunggah.';

  @override
  String imageUploadFailed(String error) {
    return 'Unggah gambar gagal: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'Bucket gambar Supabase belum dikonfigurasi.';

  @override
  String get searchProductsPlaceholder => 'Cari produk atau SKU';

  @override
  String get inStockFilter => 'Tersedia';

  @override
  String get includeInactiveFilter => 'Sertakan yang tidak aktif';

  @override
  String get sortName => 'Nama';

  @override
  String get sortPriceAsc => 'Harga rendah-tinggi';

  @override
  String get sortPriceDesc => 'Harga tinggi-rendah';

  @override
  String get sortStockAsc => 'Stok rendah-tinggi';

  @override
  String get sortStockDesc => 'Stok tinggi-rendah';

  @override
  String get sortPopularity => 'Popularitas';

  @override
  String get gridView => 'Kisi';

  @override
  String get listView => 'Daftar';

  @override
  String get noProductsMatch =>
      'Tidak ada produk yang cocok dengan filter Anda.';

  @override
  String get clearFilters => 'Bersihkan filter';

  @override
  String get allProductsLoaded => 'Semua produk dimuat.';

  @override
  String get saveProductTitle => 'Simpan produk';

  @override
  String get addProductTitle => 'Tambah produk';

  @override
  String get editProductTitle => 'Edit produk';

  @override
  String get productNameLabel => 'Nama';

  @override
  String get skuLabel => 'SKU / Referensi';

  @override
  String get priceLabel => 'Harga (DZD)';

  @override
  String get promoPriceLabel => 'Harga promo (DZD)';

  @override
  String get optionalHelper => 'Opsional';

  @override
  String get imageLabel => 'URL gambar atau jalur penyimpanan';

  @override
  String get uploadImageButton => 'Unggah gambar';

  @override
  String get replaceImageButton => 'Ganti gambar';

  @override
  String get uploadingButton => 'Mengunggah...';

  @override
  String get stockLabel => 'Stok';

  @override
  String get popularityLabel => 'Popularitas';

  @override
  String get activeLabel => 'Aktif';

  @override
  String get saveButton => 'Simpan';

  @override
  String get savingButton => 'Menyimpan...';

  @override
  String get unavailableStatus => 'Tidak tersedia';

  @override
  String get outOfStockStatus => 'Stok habis';

  @override
  String get lowStockStatus => 'Stok rendah';

  @override
  String get inactiveStatus => 'Tidak aktif';

  @override
  String get promoStatus => 'Promosi';

  @override
  String get cartEmpty => 'Keranjang kosong.';

  @override
  String get yourCart => 'Keranjang Anda';

  @override
  String get clearCart => 'Bersihkan';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryLabel => 'Pengiriman';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Telepon';

  @override
  String get addressLabel => 'Alamat';

  @override
  String get noteLabel => 'Catatan';

  @override
  String get checkoutButton => 'Selesaikan pembelian';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count item';
  }

  @override
  String orderNumber(String id) {
    return 'Pesanan #$id';
  }

  @override
  String get changeRoleTooltip => 'Ubah peran (Simulasi)';

  @override
  String get orderNotFound => 'Pesanan tidak ditemukan';

  @override
  String get globalStatus => 'Status global';

  @override
  String get dateLabel => 'Tanggal';

  @override
  String get customerLabel => 'Pelanggan';

  @override
  String get paymentLabel => 'Pembayaran';

  @override
  String get productsLabel => 'Produk';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Harga: $price DZD x $quantity';
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
  String get noShipmentsYet => 'Belum ada pengiriman.';

  @override
  String shipmentsCount(int count) {
    return 'Pengiriman ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Paket: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Kurir: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Dikirim pada';

  @override
  String get itemsInPackage => 'Item dalam paket ini:';

  @override
  String get confirmOrderButton => 'Konfirmasi pesanan';

  @override
  String get allocateStockButton => 'Alokasikan stok';

  @override
  String get startPickingButton => 'Mulai picking';

  @override
  String get packingFinishedButton => 'Pengemasan selesai (Dikemas)';

  @override
  String get shipButton => 'Label & kirim';

  @override
  String setInTransitButton(String tracking) {
    return 'Set dalam transit ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Konfirmasi pengantaran ($tracking)';
  }

  @override
  String get requestReturnButton => 'Minta pengembalian';

  @override
  String get newShipmentTitle => 'Pengiriman baru';

  @override
  String get allItemIncludedNote =>
      'Semua item akan disertakan dalam paket ini untuk contoh ini.';

  @override
  String get trackingNumberLabel => 'Nomor pelacakan';

  @override
  String get adminStatusTitle => 'Administrasi : Status';

  @override
  String get phoneAddressRequired => 'Telepon dan alamat diperlukan.';

  @override
  String get orderFailedLong => 'Pesanan gagal.';

  @override
  String orderCreatedLong(String id) {
    return 'Pesanan dibuat: $id';
  }

  @override
  String get placingOrderButton => 'Memproses pesanan...';

  @override
  String get placeOrderButton => 'Buat pesanan';

  @override
  String get loadMoreButton => 'Muat lebih banyak';

  @override
  String get searchOrderPlaceholder => 'Cari pesanan...';

  @override
  String get allFilter => 'Semua';

  @override
  String get orderConfirmedStep => 'Dikonfirmasi';

  @override
  String get shippedStep => 'Dikirim';

  @override
  String get deliveredStep => 'Dikirimkan';

  @override
  String get unknownDate => 'Tidak diketahui';

  @override
  String get p2pMessengerTitle => 'Pesan P2P';

  @override
  String errorWithDetails(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String get myQrCode => 'QR Code saya';

  @override
  String get shareQrCodeTitle => 'Bagikan QR Code Anda';

  @override
  String get shareQrCodeSubtitle =>
      'Biarkan teman Anda memindai kode ini untuk menambahkan Anda ke kontak mereka.';

  @override
  String get takeScreenshotToShare =>
      'Ambil tangkapan layar untuk membagikan QR Code Anda.';

  @override
  String get initErrorTitle => 'Kesalahan inisialisasi';

  @override
  String get messagesTitle => 'Pesan';

  @override
  String get addContactTooltip => 'Tambah kontak';

  @override
  String get noConversations => 'Belum ada percakapan';

  @override
  String get addContactToStart => 'Tambahkan kontak untuk mulai mengobrol';

  @override
  String get typingStatus => 'mengetik...';

  @override
  String get sayHello => 'Sapa! ??';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get addFriendTitle => 'Tambah teman';

  @override
  String get scanFriendQr => 'Pindai QR Code teman Anda';

  @override
  String get addContactTitle => 'Tambah kontak';

  @override
  String get yourQrCodeTitle => 'QR Code Anda';

  @override
  String get yourQrCodeSubtitle => 'Tunjukkan kode ini kepada teman Anda';

  @override
  String get notAvailable => 'Tidak tersedia';

  @override
  String get deviceIdLabel => 'ID Perangkat';

  @override
  String get contactAddedSuccess => 'Kontak berhasil ditambahkan!';

  @override
  String get dataChannelDisconnected => 'Saluran data terputus';

  @override
  String peerNotConnected(String id) {
    return 'Peer tidak terhubung: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Kesalahan mem-parsing pesan: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'QR Code tidak valid: $error';
  }

  @override
  String get missingDeviceId => 'ID Perangkat tidak ada';

  @override
  String get missingPseudo => 'Nama samaran hilang';

  @override
  String get missingPublicKey => 'Kunci publik hilang';

  @override
  String get cannotAddSelfError => 'Tidak dapat menambahkan diri sendiri';

  @override
  String get invalidPublicKeyFormat => 'Format kunci publik tidak valid';

  @override
  String errorParsingQrCode(String error) {
    return 'Kesalahan mem-parsing QR Code: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Teman';

  @override
  String get encryptedMessage => '[Pesan terenkripsi]';

  @override
  String get youEncryptedMessage => 'Anda: [Pesan terenkripsi]';

  @override
  String get imageMessage => '??? Gambar';

  @override
  String get fileMessage => '?? Berkas';

  @override
  String get newMessage => 'Pesan baru';

  @override
  String get reply => 'Balas';

  @override
  String get quickReply => 'Balasan cepat';

  @override
  String get markAsRead => 'Tandai sudah dibaca';

  @override
  String get isTyping => 'sedang mengetik...';

  @override
  String get typingIndicator => 'Mengetik...';

  @override
  String get vocalMessage => 'Pesan suara';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Izin';

  @override
  String get trace => 'Jejak';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Silakan perbaiki kesalahan pada formulir.';

  @override
  String get saveFailed => 'Gagal menyimpan.';

  @override
  String get itemsLabel => 'Item';

  @override
  String get productInfoSection => 'Informasi';

  @override
  String get productImageSection => 'Gambar';

  @override
  String get productStockStatusSection => 'Stok & status';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get priceRequired => 'Harga wajib diisi';

  @override
  String get invalidPrice => 'Masukkan harga yang valid';

  @override
  String get invalidPromoPrice => 'Masukkan harga promo yang valid';

  @override
  String get promoLowerThanPrice => 'Harga promo harus lebih rendah dari harga';

  @override
  String get invalidStock => 'Masukkan stok yang valid';

  @override
  String get popularityHelper => 'Semakin tinggi semakin populer';

  @override
  String get invalidPopularity => 'Masukkan popularitas yang valid';

  @override
  String get addToCart => 'Tambah ke keranjang';

  @override
  String get stockUnknown => 'Stok tidak diketahui';

  @override
  String get startChatPrompt => 'Mulai percakapan';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (Waktu nyata)';

  @override
  String get clear => 'Bersihkan';

  @override
  String get warehouseRole => 'Gudang';

  @override
  String get carrierRole => 'Pengangkut';

  @override
  String get supportRole => 'Dukungan';

  @override
  String get orderStatusCreated => 'Dibuat';

  @override
  String get orderStatusPendingPayment => 'Pembayaran tertunda';

  @override
  String get orderStatusPaid => 'Dibayar';

  @override
  String get orderStatusPaymentFailed => 'Pembayaran gagal';

  @override
  String get orderStatusCancelRequested => 'Pembatalan diminta';

  @override
  String get orderStatusCancelled => 'Dibatalkan';

  @override
  String get orderStatusOrderConfirmed => 'Dikonfirmasi';

  @override
  String get orderStatusStockAllocated => 'Stok dialokasikan';

  @override
  String get orderStatusBackorder => 'Pesanan tertunda';

  @override
  String get orderStatusPicking => 'Pengambilan';

  @override
  String get orderStatusPacked => 'Dikemas';

  @override
  String get orderStatusReadyToShip => 'Siap dikirim';

  @override
  String get orderStatusPartiallyShipped => 'Dikirim sebagian';

  @override
  String get orderStatusPartiallyDelivered => 'Diterima sebagian';

  @override
  String get orderStatusDeliveryFailed => 'Pengiriman gagal';

  @override
  String get orderStatusException => 'Eksepsi';

  @override
  String get orderStatusReturnRequested => 'Pengembalian diminta';

  @override
  String get orderStatusReturnInTransit => 'Pengembalian dalam perjalanan';

  @override
  String get orderStatusReturnReceived => 'Pengembalian diterima';

  @override
  String get orderStatusRefundPending => 'Pengembalian dana tertunda';

  @override
  String get orderStatusRefunded => 'Dikembalikan';

  @override
  String get orderStatusClosed => 'Ditutup';

  @override
  String get shipmentStatusLabelCreated => 'Label dibuat';

  @override
  String get shipmentStatusPickedUp => 'Diambil';

  @override
  String get shipmentStatusInTransit => 'Dalam perjalanan';

  @override
  String get shipmentStatusArrivedAtHub => 'Tiba di hub';

  @override
  String get shipmentStatusCustomsClearance => 'Bea cukai';

  @override
  String get shipmentStatusOutForDelivery => 'Dalam pengantaran';

  @override
  String get shipmentStatusDelivered => 'Terkirim';

  @override
  String get shipmentStatusDeliveryFailed => 'Pengiriman gagal';

  @override
  String get shipmentStatusException => 'Eksepsi';

  @override
  String get shipmentStatusLost => 'Hilang';

  @override
  String get shipmentStatusDamaged => 'Rusak';

  @override
  String get shipmentStatusReturnToSender => 'Dikembalikan ke pengirim';

  @override
  String get returnStatusRequested => 'Diminta';

  @override
  String get returnStatusAuthorized => 'Diotorisasi';

  @override
  String get returnStatusLabelIssued => 'Label diterbitkan';

  @override
  String get returnStatusInTransit => 'Dalam perjalanan';

  @override
  String get returnStatusReceived => 'Diterima';

  @override
  String get returnStatusRejected => 'Ditolak';

  @override
  String get returnStatusRefundPending => 'Pengembalian dana tertunda';

  @override
  String get returnStatusRefunded => 'Dikembalikan';

  @override
  String get paymentStatusPending => 'Tertunda';

  @override
  String get paymentStatusAuthorized => 'Diotorisasi';

  @override
  String get paymentStatusCaptured => 'Ditagih';

  @override
  String get paymentStatusVoided => 'Dibatalkan';

  @override
  String get paymentStatusRefunded => 'Dikembalikan';

  @override
  String get paymentStatusFailed => 'Gagal';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'Terlaris';

  @override
  String get readMore => 'baca selengkapnya';

  @override
  String get showLess => 'lebih sedikit';
}
