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
  String get admin => 'Administrador';

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
  String get adminTooltip => 'Administrador';

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
  String get tabTraces => 'Tra?os';

  @override
  String get tabContacts => 'Contactos';

  @override
  String get tabConfig => 'Configura??o';

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
  String get online => 'Ligado';

  @override
  String get offline => 'Desligado';

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
  String get messengerDashboard => 'Painel do Sigma Messenger';

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
  String get supportChatPlaceholder => 'Mensagem para o suporte...';

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
  String get email => 'E-mail';

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
  String get client => 'Cliente';

  @override
  String get vendor => 'Vendedor';

  @override
  String get deliveryPerson => 'Estafeta';

  @override
  String get wholesaler => 'Grossista';

  @override
  String get vocalSigma => 'Voz Sigma';

  @override
  String get defaultMessageContent => 'Mensagem';

  @override
  String get myContacts => 'Os meus contactos';

  @override
  String get myQrCodeTooltip => 'O meu QR Code';

  @override
  String get scanFriendTooltip => 'Scanear um amigo';

  @override
  String get friendAddedSuccess => '? Amigo adicionado com sucesso!';

  @override
  String get editPseudoMenu => 'Editar o meu pseudo';

  @override
  String get myPseudoTitle => 'O meu pseudo';

  @override
  String get enterPseudoHint => 'Introduza o seu pseudo';

  @override
  String get noContacts => 'Sem contactos';

  @override
  String get scanFriendToStart => 'Scaneie o QR Code de um amigo para come?ar';

  @override
  String get scanFriendButton => 'Scanear um amigo';

  @override
  String get addedOn => 'Adicionado em';

  @override
  String get scanQrCodeTitle => 'Scanear um QR Code';

  @override
  String get qrCodeUnreadable => 'QR Code ileg?vel, tente novamente.';

  @override
  String get invalidMistralQr => 'Este QR Code n?o ? do Mistral P2P.';

  @override
  String invalidLinkError(String error) {
    return 'Link inv?lido: $error';
  }

  @override
  String get cannotAddSelf => '?? N?o pode adicionar-se a si pr?prio!';

  @override
  String get friendAlreadyAdded => '?? Este amigo j? est? nos seus contactos.';

  @override
  String get placeQrInFrame => 'Coloque o QR Code no enquadramento';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get flashlightTooltip => 'Lanterna';

  @override
  String get shareLinkTooltip => 'Partilhar link';

  @override
  String inviteText(String link) {
    return 'Adiciona-me no Mistral2laude P2P!\n$link';
  }

  @override
  String get inviteSubject => 'Convite Mistral2laude P2P';

  @override
  String get scanMeText =>
      'Scaneie este QR Code\npara me adicionar como contacto';

  @override
  String get microphonePermissionDenied => 'Permiss?o do microfone negada';

  @override
  String get connectionNotEstablished =>
      '?? Liga??o n?o estabelecida. Mensagem guardada localmente.';

  @override
  String get noMessagesYet => 'Sem mensagens.\nEnvie a primeira! ??';

  @override
  String get statusConnected => 'Ligado';

  @override
  String get statusConnecting => 'A ligar...';

  @override
  String get statusFailed => 'Falhou';

  @override
  String get statusOffline => 'Desligado';

  @override
  String get recordingHint => '?? A gravar...';

  @override
  String get messageHint => 'Mensagem...';

  @override
  String get connectingHint => 'A ligar...';

  @override
  String get initFailed => 'Falha na inicializa??o';

  @override
  String get defaultUserPseudo => 'Utilizador M2C';

  @override
  String get mobileDevice => 'Dispositivo m?vel';

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String get productsTab => 'Produtos';

  @override
  String get logisticsTab => 'Logistics';

  @override
  String get ordersTab => 'Encomendas';

  @override
  String get cartTab => 'Carrinho';

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
  String get orderStatusShipped => 'Enviada';

  @override
  String get orderStatusDelivered => 'Entregue';

  @override
  String get clientModeTooltip => 'Modo cliente';

  @override
  String get adminModeTooltip => 'Modo administrador';

  @override
  String get addProductTooltip => 'Adicionar produto';

  @override
  String get orderCreated => 'Encomenda criada.';

  @override
  String get orderFailed => 'Encomenda falhou.';

  @override
  String get productCreated => 'Produto criado.';

  @override
  String get productUpdated => 'Produto atualizado.';

  @override
  String get productDeleted => 'Produto eliminado.';

  @override
  String get deleteFailed => 'Falha ao eliminar.';

  @override
  String get deleteProductTitle => 'Eliminar produto';

  @override
  String deleteProductConfirm(String name) {
    return 'Eliminar \"$name\"?';
  }

  @override
  String get imageUploaded => 'Imagem enviada.';

  @override
  String imageUploadFailed(String error) {
    return 'Falha no envio da imagem: $error';
  }

  @override
  String get supabaseBucketNotConfigured =>
      'O bucket de imagens do Supabase n?o est? configurado.';

  @override
  String get searchProductsPlaceholder => 'Pesquisar produtos ou SKU';

  @override
  String get inStockFilter => 'Em stock';

  @override
  String get includeInactiveFilter => 'Incluir inativos';

  @override
  String get sortName => 'Nome';

  @override
  String get sortPriceAsc => 'Pre?o crescente';

  @override
  String get sortPriceDesc => 'Pre?o decrescente';

  @override
  String get sortStockAsc => 'Stock crescente';

  @override
  String get sortStockDesc => 'Stock decrescente';

  @override
  String get sortPopularity => 'Popularidade';

  @override
  String get gridView => 'Grelha';

  @override
  String get listView => 'Lista';

  @override
  String get noProductsMatch => 'Nenhum produto corresponde aos seus filtros.';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get allProductsLoaded => 'Todos os produtos carregados.';

  @override
  String get saveProductTitle => 'Guardar produto';

  @override
  String get addProductTitle => 'Adicionar produto';

  @override
  String get editProductTitle => 'Editar produto';

  @override
  String get productNameLabel => 'Nome';

  @override
  String get skuLabel => 'SKU / Refer?ncia';

  @override
  String get priceLabel => 'Pre?o (DZD)';

  @override
  String get promoPriceLabel => 'Pre?o promocional (DZD)';

  @override
  String get optionalHelper => 'Opcional';

  @override
  String get imageLabel => 'URL da imagem ou caminho de armazenamento';

  @override
  String get uploadImageButton => 'Enviar imagem';

  @override
  String get replaceImageButton => 'Substituir imagem';

  @override
  String get uploadingButton => 'A enviar...';

  @override
  String get stockLabel => 'Stock';

  @override
  String get popularityLabel => 'Popularidade';

  @override
  String get activeLabel => 'Ativo';

  @override
  String get saveButton => 'Guardar';

  @override
  String get savingButton => 'A guardar...';

  @override
  String get unavailableStatus => 'Indispon?vel';

  @override
  String get outOfStockStatus => 'Sem stock';

  @override
  String get lowStockStatus => 'Stock baixo';

  @override
  String get inactiveStatus => 'Inativo';

  @override
  String get promoStatus => 'Promo??o';

  @override
  String get cartEmpty => 'O carrinho est? vazio.';

  @override
  String get yourCart => 'O seu carrinho';

  @override
  String get clearCart => 'Limpar';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get deliveryLabel => 'Entrega';

  @override
  String get totalLabel => 'Total';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get addressLabel => 'Morada';

  @override
  String get noteLabel => 'Nota';

  @override
  String get checkoutButton => 'Finalizar compra';

  @override
  String orderTotal(String amount) {
    return 'Total $amount DZD';
  }

  @override
  String itemsCount(int count) {
    return '$count itens';
  }

  @override
  String orderNumber(String id) {
    return 'Encomenda #$id';
  }

  @override
  String get changeRoleTooltip => 'Alterar fun??o (Simula??o)';

  @override
  String get orderNotFound => 'Encomenda n?o encontrada';

  @override
  String get globalStatus => 'Estado global';

  @override
  String get dateLabel => 'Data';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get paymentLabel => 'Pagamento';

  @override
  String get productsLabel => 'Produtos';

  @override
  String priceXQuantity(String price, int quantity) {
    return 'Pre?o: $price DZD x $quantity';
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
  String get noShipmentsYet => 'Ainda sem envios.';

  @override
  String shipmentsCount(int count) {
    return 'Envios ($count)';
  }

  @override
  String packageNumber(String tracking) {
    return 'Pacote: $tracking';
  }

  @override
  String carrierLabel(String name) {
    return 'Transportadora: $name';
  }

  @override
  String get packageId => 'ID';

  @override
  String get shippedOn => 'Enviado em';

  @override
  String get itemsInPackage => 'Itens neste pacote:';

  @override
  String get confirmOrderButton => 'Confirmar encomenda';

  @override
  String get allocateStockButton => 'Atribuir stock';

  @override
  String get startPickingButton => 'Iniciar picking';

  @override
  String get packingFinishedButton => 'Embalagem conclu?da (Embalado)';

  @override
  String get shipButton => 'Etiquetar e enviar';

  @override
  String setInTransitButton(String tracking) {
    return 'Colocar em tr?nsito ($tracking)';
  }

  @override
  String confirmDeliveryButton(String tracking) {
    return 'Confirmar entrega ($tracking)';
  }

  @override
  String get requestReturnButton => 'Solicitar devolu??o';

  @override
  String get newShipmentTitle => 'Novo envio';

  @override
  String get allItemIncludedNote =>
      'Todos os itens ser?o inclu?dos neste pacote para este exemplo.';

  @override
  String get trackingNumberLabel => 'N?mero de rastreio';

  @override
  String get adminStatusTitle => 'Administra??o : Estado';

  @override
  String get phoneAddressRequired => 'Telefone e morada s?o obrigat?rios.';

  @override
  String get orderFailedLong => 'Encomenda falhou.';

  @override
  String orderCreatedLong(String id) {
    return 'Encomenda criada: $id';
  }

  @override
  String get placingOrderButton => 'A fazer encomenda...';

  @override
  String get placeOrderButton => 'Fazer encomenda';

  @override
  String get loadMoreButton => 'Carregar mais';

  @override
  String get searchOrderPlaceholder => 'Pesquisar uma encomenda...';

  @override
  String get allFilter => 'Todos';

  @override
  String get orderConfirmedStep => 'Confirmado';

  @override
  String get shippedStep => 'Enviado';

  @override
  String get deliveredStep => 'Entregue';

  @override
  String get unknownDate => 'Desconhecido';

  @override
  String get p2pMessengerTitle => 'Mensagens P2P';

  @override
  String errorWithDetails(String message) {
    return 'Erro: $message';
  }

  @override
  String get myQrCode => 'O meu QR Code';

  @override
  String get shareQrCodeTitle => 'Partilhe o seu QR Code';

  @override
  String get shareQrCodeSubtitle =>
      'Deixe os seus amigos scanear este c?digo para o adicionar aos contactos.';

  @override
  String get takeScreenshotToShare =>
      'Tire uma captura de ecr? para partilhar o seu QR Code.';

  @override
  String get initErrorTitle => 'Erro de inicializa??o';

  @override
  String get messagesTitle => 'Mensagens';

  @override
  String get addContactTooltip => 'Adicionar contacto';

  @override
  String get noConversations => 'Sem conversas ainda';

  @override
  String get addContactToStart =>
      'Adicione um contacto para come?ar a conversar';

  @override
  String get typingStatus => 'a escrever...';

  @override
  String get sayHello => 'Diga ol?! ??';

  @override
  String get yesterday => 'Ontem';

  @override
  String get addFriendTitle => 'Adicionar amigo';

  @override
  String get scanFriendQr => 'Scaneie o QR Code do seu amigo';

  @override
  String get addContactTitle => 'Adicionar contacto';

  @override
  String get yourQrCodeTitle => 'O seu QR Code';

  @override
  String get yourQrCodeSubtitle => 'Mostre este c?digo ao seu amigo';

  @override
  String get notAvailable => 'N/D';

  @override
  String get deviceIdLabel => 'ID do dispositivo';

  @override
  String get contactAddedSuccess => 'Contacto adicionado com sucesso!';

  @override
  String get dataChannelDisconnected => 'Canal de dados desconectado';

  @override
  String peerNotConnected(String id) {
    return 'Par n?o conectado: $id';
  }

  @override
  String errorParsingMessage(String error) {
    return 'Erro ao analisar mensagem: $error';
  }

  @override
  String invalidQrCode(String error) {
    return 'QR Code inv?lido: $error';
  }

  @override
  String get missingDeviceId => 'ID do dispositivo ausente';

  @override
  String get missingPseudo => 'Pseudo em falta';

  @override
  String get missingPublicKey => 'Chave p?blica em falta';

  @override
  String get cannotAddSelfError => 'N?o pode adicionar-se a si pr?prio';

  @override
  String get invalidPublicKeyFormat => 'Formato de chave p?blica inv?lido';

  @override
  String errorParsingQrCode(String error) {
    return 'Erro ao analisar QR Code: $error';
  }

  @override
  String get mistral2laudeTitle => 'Mistral2laude P2P';

  @override
  String get friendLabel => 'Amigo';

  @override
  String get encryptedMessage => '[Mensagem encriptada]';

  @override
  String get youEncryptedMessage => 'Tu: [Mensagem encriptada]';

  @override
  String get imageMessage => '??? Imagem';

  @override
  String get fileMessage => '?? Ficheiro';

  @override
  String get newMessage => 'Nova mensagem';

  @override
  String get reply => 'Responder';

  @override
  String get quickReply => 'Resposta r?pida';

  @override
  String get markAsRead => 'Marcar como lida';

  @override
  String get isTyping => 'est? a escrever...';

  @override
  String get typingIndicator => 'A escrever...';

  @override
  String get vocalMessage => 'Mensagem de voz';

  @override
  String get gps => 'GPS';

  @override
  String get permissions => 'Permiss?es';

  @override
  String get trace => 'Rasto';

  @override
  String get mainChannelValue => 'WebRTC P2P';

  @override
  String get formErrors => 'Por favor, corrija os erros do formulário.';

  @override
  String get saveFailed => 'Falha ao salvar.';

  @override
  String get itemsLabel => 'Itens';

  @override
  String get productInfoSection => 'Informações';

  @override
  String get productImageSection => 'Imagem';

  @override
  String get productStockStatusSection => 'Estoque e status';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String get priceRequired => 'Preço é obrigatório';

  @override
  String get invalidPrice => 'Insira um preço válido';

  @override
  String get invalidPromoPrice => 'Insira um preço promocional válido';

  @override
  String get promoLowerThanPrice =>
      'O preço promocional deve ser menor que o preço';

  @override
  String get invalidStock => 'Insira um estoque válido';

  @override
  String get popularityHelper => 'Quanto maior, mais popular';

  @override
  String get invalidPopularity => 'Insira uma popularidade válida';

  @override
  String get addToCart => 'Adicionar ao carrinho';

  @override
  String get stockUnknown => 'Estoque desconhecido';

  @override
  String get startChatPrompt => 'Comece a conversa';

  @override
  String get realtimeMessengerTitle => 'Sigma Messenger (Tempo real)';

  @override
  String get clear => 'Limpar';

  @override
  String get warehouseRole => 'Armazém';

  @override
  String get carrierRole => 'Transportadora';

  @override
  String get supportRole => 'Suporte';

  @override
  String get orderStatusCreated => 'Criada';

  @override
  String get orderStatusPendingPayment => 'Pagamento pendente';

  @override
  String get orderStatusPaid => 'Paga';

  @override
  String get orderStatusPaymentFailed => 'Falha no pagamento';

  @override
  String get orderStatusCancelRequested => 'Cancelamento solicitado';

  @override
  String get orderStatusCancelled => 'Cancelada';

  @override
  String get orderStatusOrderConfirmed => 'Confirmada';

  @override
  String get orderStatusStockAllocated => 'Estoque alocado';

  @override
  String get orderStatusBackorder => 'Pedido em espera';

  @override
  String get orderStatusPicking => 'Separação';

  @override
  String get orderStatusPacked => 'Embalada';

  @override
  String get orderStatusReadyToShip => 'Pronta para envio';

  @override
  String get orderStatusPartiallyShipped => 'Parcialmente enviada';

  @override
  String get orderStatusPartiallyDelivered => 'Parcialmente entregue';

  @override
  String get orderStatusDeliveryFailed => 'Falha na entrega';

  @override
  String get orderStatusException => 'Exceção';

  @override
  String get orderStatusReturnRequested => 'Devolução solicitada';

  @override
  String get orderStatusReturnInTransit => 'Devolução em trânsito';

  @override
  String get orderStatusReturnReceived => 'Devolução recebida';

  @override
  String get orderStatusRefundPending => 'Reembolso pendente';

  @override
  String get orderStatusRefunded => 'Reembolsada';

  @override
  String get orderStatusClosed => 'Encerrada';

  @override
  String get shipmentStatusLabelCreated => 'Etiqueta criada';

  @override
  String get shipmentStatusPickedUp => 'Coletado';

  @override
  String get shipmentStatusInTransit => 'Em trânsito';

  @override
  String get shipmentStatusArrivedAtHub => 'Chegou ao hub';

  @override
  String get shipmentStatusCustomsClearance => 'Desembaraço aduaneiro';

  @override
  String get shipmentStatusOutForDelivery => 'Saiu para entrega';

  @override
  String get shipmentStatusDelivered => 'Entregue';

  @override
  String get shipmentStatusDeliveryFailed => 'Falha na entrega';

  @override
  String get shipmentStatusException => 'Exceção';

  @override
  String get shipmentStatusLost => 'Perdido';

  @override
  String get shipmentStatusDamaged => 'Danificado';

  @override
  String get shipmentStatusReturnToSender => 'Devolvido ao remetente';

  @override
  String get returnStatusRequested => 'Solicitado';

  @override
  String get returnStatusAuthorized => 'Autorizado';

  @override
  String get returnStatusLabelIssued => 'Etiqueta emitida';

  @override
  String get returnStatusInTransit => 'Em trânsito';

  @override
  String get returnStatusReceived => 'Recebido';

  @override
  String get returnStatusRejected => 'Rejeitado';

  @override
  String get returnStatusRefundPending => 'Reembolso pendente';

  @override
  String get returnStatusRefunded => 'Reembolsado';

  @override
  String get paymentStatusPending => 'Pendente';

  @override
  String get paymentStatusAuthorized => 'Autorizado';

  @override
  String get paymentStatusCaptured => 'Capturado';

  @override
  String get paymentStatusVoided => 'Anulado';

  @override
  String get paymentStatusRefunded => 'Reembolsado';

  @override
  String get paymentStatusFailed => 'Falhou';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get orderNoteLabel => 'Order Note (optional)';

  @override
  String addedToCart(String product) {
    return '$product added to cart';
  }

  @override
  String get bestSeller => 'Mais vendido';

  @override
  String get readMore => 'ler mais';

  @override
  String get showLess => 'ver menos';
}
