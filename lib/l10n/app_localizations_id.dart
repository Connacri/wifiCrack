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
  String confirmDeleteConversation(Object pseudo) {
    return 'Hapus semua pesan dengan $pseudo?';
  }

  @override
  String get conversationDeleted => 'Obrolan dihapus secara lokal.';

  @override
  String get p2pSecure => 'P2P Aman';

  @override
  String coinsForUser(Object pseudo) {
    return 'Koin untuk $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'Kesalahan pemindaian: $error';
  }

  @override
  String get scanNotSupported =>
      'Pemindaian WiFi tidak didukung pada perangkat ini.';

  @override
  String get gpsDisabled => 'GPS dinonaktifkan.';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
