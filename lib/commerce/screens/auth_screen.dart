import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../data/sources/supabase_service.dart';
import '../../data/sources/user_data_service.dart';
import '../../l10n/app_localizations.dart';
import '../services/profile_service.dart';
import 'commerce_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _profileService = ProfileService();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    // Redirection automatique immédiate si une session Firebase existe
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    // On attend un petit délai pour s'assurer que Firebase est bien initialisé
    await Future.delayed(Duration.zero);
    final user = _auth.currentUser;
    if (user != null && mounted) {
      debugPrint("📱 Session active détectée pour: ${user.email}");
      _handleUserNavigation(user);
    }
  }

  /// Authentification Google (Mobile)
  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final auth = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);
      final idToken = googleUser.authentication.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null || accessToken == null)
        throw Exception("Tokens manquants");

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      _handleUserNavigation(userCredential.user);
    } catch (e) {
      _showError(l10n.googleError(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Authentification Email/Password (Windows & Mobile)
  Future<void> _processEmailAuth() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showError(l10n.fillAllFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential;
      if (_isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
      }
      _handleUserNavigation(userCredential.user);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? l10n.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showError(l10n.email);
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSuccess(l10n.resetEmailSent);
    } catch (e) {
      _showError("${l10n.error}: $e");
    }
  }

  /// Gestion de la navigation après succès
  Future<void> _handleUserNavigation(User? user) async {
    if (user == null) return;

    // Enregistrement obligatoire dans Supabase pour éviter l'erreur de clé étrangère
    try {
      final supabase = context.read<SupabaseService>();
      final userData = context.read<UserDataService>();
      final deviceModel = await userData.getDeviceModel();
      await supabase.registerUser(
        device_id: user.uid, // On utilise l'UID Firebase comme ID dans Supabase
        model: deviceModel,
        pseudo: user.displayName ?? user.email?.split('@')[0],
      );
    } catch (e) {
      debugPrint("⚠️ Erreur synchro Supabase: $e");
    }

    final hasProfile = await _profileService.hasProfile();
    if (!hasProfile) {
      if (mounted) _showRoleSelectionDialog(user);
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CommerceScreen(userId: user.uid)),
        );
      }
    }
  }

  void _showRoleSelectionDialog(User user) {
    String? selectedRole;
    final l10n = AppLocalizations.of(context)!;
    final roles = [l10n.client, l10n.vendor, l10n.deliveryPerson, l10n.wholesaler];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.chooseRole),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles
                .map(
                  (role) => RadioListTile<String>(
                    title: Text(role),
                    value: role,
                    groupValue: selectedRole,
                    onChanged: (val) =>
                        setDialogState(() => selectedRole = val),
                  ),
                )
                .toList(),
          ),
          actions: [
            FilledButton(
              onPressed: selectedRole == null
                  ? null
                  : () async {
                      await _profileService.createUserProfile(
                        role: selectedRole!,
                        displayName:
                            user.displayName ??
                            user.email?.split('@')[0] ??
                            l10n.user,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommerceScreen(userId: user.uid),
                          ),
                        );
                      }
                    },
              child: Text(l10n.validate),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.authTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.storefront,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? l10n.commerceLogin : l10n.createAccount,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Formulaire Email/Password
                  TextField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),

                  _isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: FilledButton(
                                onPressed: _processEmailAuth,
                                child: Text(
                                  _isLogin ? l10n.login : l10n.createAccount,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _isLogin = !_isLogin),
                              child: Text(
                                _isLogin
                                    ? l10n.noAccount
                                    : l10n.hasAccount,
                              ),
                            ),
                            if (_isLogin)
                              TextButton(
                                onPressed: _resetPassword,
                                child: Text(
                                  l10n.forgotPassword,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                          ],
                        ),

                  const Divider(height: 48),

                  // Google Auth (Masqué sur Windows si souhaité, ou laissé en option)
                  if (!Platform.isWindows)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.login, color: Colors.red),
                      label: Text(l10n.loginGoogle),
                      onPressed: _isLoading ? null : _signInWithGoogle,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
