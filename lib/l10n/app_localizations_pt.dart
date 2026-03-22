// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'WiFi Fibre Hack';

  @override
  String get home => 'Início';

  @override
  String get map => 'Mapa';

  @override
  String get scan => 'Escanear';

  @override
  String get settings => 'Configurações';

  @override
  String get admin => 'Admin';

  @override
  String get commerce => 'Comércio';

  @override
  String get p2pChat => 'Chat P2P';

  @override
  String get publishAd => 'Publicar anúncio';

  @override
  String get connect => 'Conectar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get copy => 'Copiar';

  @override
  String get share => 'Compartilhar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get search => 'Pesquisar';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get password => 'Senha';

  @override
  String get pseudo => 'Apelido';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get system => 'Sistema';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get profileTooltip => 'Perfil';

  @override
  String get adminTooltip => 'Admin';

  @override
  String get chatTooltip => 'Chat';

  @override
  String get p2pTooltip => 'P2P';

  @override
  String get scanWifi => 'Escanear WiFi';

  @override
  String get scanning => 'Analisando...';

  @override
  String get noNetworks => 'Nenhuma rede encontrada';

  @override
  String get permissionDenied => 'Permissão negada';

  @override
  String get fixPermissions => 'Corrigir permissões';

  @override
  String get detected => 'Detetado';

  @override
  String get connected => 'Conectado';

  @override
  String get failed => 'Falhou';

  @override
  String get coins => 'Moedas';

  @override
  String get publishAdEarn => 'Publicar anúncio e ganhar';

  @override
  String get adminDashboardTitle => 'Sigma Dashboard Pro';

  @override
  String get logoutSnackBar => 'Desconectado do administrador.';

  @override
  String get logoutTooltip => 'Sair localmente';

  @override
  String get tabStats => 'Estatísticas';

  @override
  String get tabAds => 'Anúncios';

  @override
  String get tabTargets => 'Alvos';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabTraces => 'Traces';

  @override
  String get tabContacts => 'Contactos';

  @override
  String get tabConfig => 'Config';

  @override
  String get securityAdmin => '🔐 Segurança Admin';

  @override
  String get changePasswordInfo =>
      'Altere a senha de acesso ao painel. Esta alteração é imediata para todos os dispositivos.';

  @override
  String get minPasswordError => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get passwordUpdateSuccess =>
      '✅ Senha de Admin atualizada no Supabase!';

  @override
  String get passwordUpdateError => '❌ Erro durante a atualização.';

  @override
  String get addCarousel => '📢 Adicionar ao Carrossel';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get publish => 'Publicar';

  @override
  String get bannerAdded => 'Banner adicionado!';

  @override
  String get userSubmissionsManagement =>
      'Gestão de submissões de utilizadores';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get model => 'Modelo';

  @override
  String get coinsLabel => 'Moedas';

  @override
  String get chat => 'Chat';

  @override
  String get giveCoins => 'Dar moedas';

  @override
  String get coinsAmountLabel => 'Número de moedas';

  @override
  String get add => 'Adicionar';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get searchPlaceholder => 'Pesquisar...';

  @override
  String get bannerText => 'Texto do banner';

  @override
  String get imageUrl => 'URL da imagem';

  @override
  String get externalLink => 'Link externo';

  @override
  String get editPseudo => 'Editar meu Apelido';

  @override
  String get newPseudo => 'Novo Apelido';

  @override
  String get pseudoUpdated => 'Apelido atualizado!';

  @override
  String get pseudoError => 'Apelido indisponível ou erro.';

  @override
  String get messengerDashboard => 'Sigma Messenger Dashboard';

  @override
  String get noUsersFound => 'Nenhum utilizador encontrado.';

  @override
  String get noActivityAvailable => 'Nenhuma atividade disponível.';

  @override
  String get deleteConversation => 'Apagar conversa';

  @override
  String confirmDeleteConversation(String pseudo) {
    return 'Excluir todas as mensagens com $pseudo?';
  }

  @override
  String get conversationDeleted => 'Conversa excluída localmente.';

  @override
  String get p2pSecure => 'P2P Seguro';

  @override
  String coinsForUser(String pseudo) {
    return 'Moedas para $pseudo';
  }

  @override
  String coinsAddedToUser(int amount, String pseudo) {
    return '$amount moedas adicionadas a $pseudo';
  }

  @override
  String get amountLabel => 'Montante';

  @override
  String get addCoins => 'Adicionar moedas';

  @override
  String get refreshUsers => 'Atualizar utilizadores';

  @override
  String get changePseudoTooltip => 'Alterar meu apelido';

  @override
  String get userProfile => 'Perfil';

  @override
  String p2pSecureSubtitle(String id) {
    return 'P2P Seguro • $id...';
  }

  @override
  String get deleteConversationTooltip => 'Apagar conversa';

  @override
  String get addCoinsTooltip => 'Dar moedas';

  @override
  String get coinsToAddLabel => 'Número de moedas a adicionar';

  @override
  String get messageSigmaPlaceholder => 'Mensagem Sigma...';

  @override
  String get supportChatPlaceholder => 'Message to support...';

  @override
  String get userProfileTitle => 'Perfil de utilizador';

  @override
  String get tabInfo => 'Infos';

  @override
  String get tabActivity => 'Atividade';

  @override
  String get tabSecurity => 'Segurança';

  @override
  String get tabNetwork => 'Rede';

  @override
  String get identity => 'Identidade';

  @override
  String get deviceAndSession => 'Dispositivo e Sessão';

  @override
  String get lastActivity => 'Última atividade';

  @override
  String get createdAt => 'Criado em';

  @override
  String get activitySummary => 'Resumo de atividade';

  @override
  String get eventsCollected => 'Eventos recolhidos';

  @override
  String get validGpsPoints => 'Pontos GPS válidos';

  @override
  String get maxContactsSeen => 'Contactos máx. vistos';

  @override
  String get securityStatus => 'Estado de segurança';

  @override
  String get activeSession => 'Sessão ativa';

  @override
  String get lastPing => 'Último ping';

  @override
  String agoMin(int minutes) {
    return 'há $minutes min';
  }

  @override
  String get anomalyDetected => 'Anomalia detetada';

  @override
  String get none => 'Nenhuma (heurística local)';

  @override
  String get securityNote =>
      'Nota: este separador apresenta sinais de segurança da aplicação baseados nos dados disponíveis (não é uma auditoria completa do servidor).';

  @override
  String get networkStatus => 'Estado da rede';

  @override
  String get mainChannel => 'Canal principal';

  @override
  String get presence => 'Presença';

  @override
  String get available => 'Disponível';

  @override
  String get unavailable => 'Indisponível';

  @override
  String get geolocSamples => 'Amostras de geolocalização';

  @override
  String get rawDebugData => 'Dados brutos (debug)';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get sigmaAdProposalTitle => '🚀 Propõe o teu anúncio Sigma';

  @override
  String get submitAdSuccess =>
      '✅ Submissão enviada! Aguarda a validação do administrador para as tuas moedas.';

  @override
  String get submitAdInfo => 'Envia uma imagem, uma descrição e ganha moedas!';

  @override
  String get descriptionLabel => 'Descrição';

  @override
  String get submit => 'Submeter';

  @override
  String get bonusActivated => 'Bónus de Moedas ativado! (Vídeo visto)';

  @override
  String get watchVideoBonus => 'Ver um vídeo para +50 Moedas de bónus';

  @override
  String get languageSelectorTitle => 'Select Language / Escolher idioma';

  @override
  String get imageLinkUrl => 'Link da imagem (URL)';

  @override
  String get bonusAddedText => 'Bónus de Moedas ativado! (Vídeo visto)';

  @override
  String get close => 'Fechar';

  @override
  String copiedToClipboard(String text) {
    return 'Chave copiada: $text';
  }

  @override
  String get disconnectTooltip => 'Desconectar';

  @override
  String get connectTooltip => 'Calcular e Conectar';

  @override
  String get audioUnavailable => 'Voz não disponível.';

  @override
  String get supportSigmaPro => 'Suporte Sigma Pro';

  @override
  String get p2pEncryptedChat => 'Mensagens P2P Encriptadas';

  @override
  String get needHelpMessage => 'Precisa de ajuda? Envie-nos uma mensagem.';

  @override
  String get chooseAdminRole => 'Escolha o seu cargo de Admin';

  @override
  String get configRequiredTitle => 'Configuração Necessária';

  @override
  String get configRequiredInfo => 'Para funcionar, o Sigma necessita de: \n';

  @override
  String get configVisibleNote => 'Sem isto, não estará visível no mapa Sigma.';

  @override
  String get configureNow => 'Configurar Agora';

  @override
  String get accessDenied => 'Acesso negado.';

  @override
  String sigmaKey(String key) {
    return 'Chave Sigma: $key';
  }

  @override
  String get wifiDisabled => 'O WiFi está desativado.';

  @override
  String get locationWifiPermsRequired =>
      'Permissões de localização/WiFi necessárias.';

  @override
  String get gpsRequiredAndroid =>
      'O GPS é necessário para escanear no Android.';

  @override
  String get noCompatibleNetworks =>
      'Nenhuma rede compatível detetada nas proximidades.';

  @override
  String scanError(String error) {
    return 'Erro de scan: $error';
  }

  @override
  String get scanNotSupported =>
      'O scan WiFi não é suportado neste dispositivo.';

  @override
  String get gpsDisabled => 'O GPS está desativado.';

  @override
  String scanUnavailable(String status) {
    return 'O scan está indisponível ($status).';
  }

  @override
  String get manualKeyEntryNote =>
      'Por favor, insira a chave manualmente se a ligação falhar.';

  @override
  String get authRequired => 'Autenticação necessária';

  @override
  String get chooseRole => 'Escolha o seu cargo';

  @override
  String get user => 'Utilizador';

  @override
  String get validate => 'Validar';

  @override
  String get authTitle => 'Autenticação';

  @override
  String get commerceLogin => 'Login Comércio';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get email => 'Email';

  @override
  String get forgotPassword => 'Esqueceu-se da senha?';

  @override
  String get loginGoogle => 'Continuar com Google';

  @override
  String get noAccount => 'Não tem conta? Registe-se';

  @override
  String get hasAccount => 'Já tem conta? Entrar';

  @override
  String get resetEmailSent => 'Email de redefinição enviado!';

  @override
  String get fillAllFields => 'Por favor, preencha todos os campos.';

  @override
  String googleError(String error) {
    return 'Erro Google: $error';
  }

  @override
  String get permsRequiredTitle => 'Permissões Necessárias';

  @override
  String get permsRequiredInfo =>
      'Para utilizar esta aplicação, deve imperativamente:\n\n';

  @override
  String get permsFatalNote => 'Sem isto, a aplicação não pode funcionar.';

  @override
  String get understandAndConfigure => 'Compreendi, configurar';

  @override
  String get commerceDisconnectConfirm => 'Deseja desconectar-se do comércio?';

  @override
  String get startDiscussion => 'Começar a discussão';

  @override
  String get yourMessage => 'A sua mensagem...';

  @override
  String get orderErrorUnidentified =>
      'Imposible encomendar: utilizador não identificado.';

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
