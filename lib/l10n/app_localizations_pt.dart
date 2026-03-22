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
  String confirmDeleteConversation(Object pseudo) {
    return 'Excluir todas as mensagens com $pseudo?';
  }

  @override
  String get conversationDeleted => 'Conversa excluída localmente.';

  @override
  String get p2pSecure => 'P2P Seguro';

  @override
  String coinsForUser(Object pseudo) {
    return 'Moedas para $pseudo';
  }

  @override
  String coinsAddedToUser(Object amount, Object pseudo) {
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
  String p2pSecureSubtitle(Object id) {
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
  String agoMin(Object minutes) {
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
  String copiedToClipboard(Object text) {
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
  String sigmaKey(Object key) {
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
  String scanError(Object error) {
    return 'Erro de scan: $error';
  }

  @override
  String get scanNotSupported =>
      'O scan WiFi não é suportado neste dispositivo.';

  @override
  String get gpsDisabled => 'O GPS está desativado.';

  @override
  String scanUnavailable(Object status) {
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
  String googleError(Object error) {
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
}
