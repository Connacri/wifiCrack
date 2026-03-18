import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/profile_service.dart';
import 'commerce_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final ProfileService _profileService = ProfileService();

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      // v7+ : Utilisation de authenticate() via le singleton instance
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      // v7+ : Pour obtenir l'accessToken, il faut autoriser les scopes explicitement
      final auth = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
      final idToken = googleUser.authentication.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception("Impossible de récupérer les jetons d'authentification.");
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Vérifier si l'utilisateur a déjà un profil
        final hasProfile = await _profileService.hasProfile();
        if (!hasProfile) {
          // Si non, demander de choisir un rôle
          if (mounted) _showRoleSelectionDialog(user);
        } else {
          // Si oui, aller directement au commerce
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CommerceScreen(userId: user.uid)),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Erreur de connexion Google: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de connexion: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRoleSelectionDialog(User user) {
    String? selectedRole;
    final roles = ['Client', 'Vendeur', 'Livreur', 'Grossiste'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Choisissez votre rôle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles.map((role) => RadioListTile<String>(
              title: Text(role),
              value: role,
              groupValue: selectedRole,
              onChanged: (val) => setDialogState(() => selectedRole = val),
            )).toList(),
          ),
          actions: [
            FilledButton(
              onPressed: selectedRole == null ? null : () async {
                await _profileService.createUserProfile(
                  role: selectedRole!,
                  displayName: user.displayName ?? "Utilisateur",
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => CommerceScreen(userId: user.uid)),
                  );
                }
              },
              child: const Text("Valider"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                "Bienvenue sur Commerce",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Connectez-vous pour accéder à votre profil et discuter avec les vendeurs.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              _isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      icon: Image.network("https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg", height: 24),
                      label: const Text("Se connecter avec Google"),
                      onPressed: _signInWithGoogle,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
