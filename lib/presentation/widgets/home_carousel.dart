import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/sources/supabase_service.dart';

/// Carrousel dynamique avec images et liens externes.
class HomeBanner extends StatelessWidget {
  final SupabaseService supabase;
  const HomeBanner({super.key, required this.supabase});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.fetchCarousel(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
        
        final items = snapshot.data!;
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16/9,
                viewportFraction: 0.9,
              ),
              items: items.map((item) {
                return GestureDetector(
                  onTap: () => _launchURL(item['link'] ?? ""),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(item['image_url'] ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        item['text'] ?? "",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Formulaire pour soumettre une annonce utilisateur (Ad Submission).
class AdSubmissionDialog extends StatefulWidget {
  final String userId;
  final SupabaseService supabase;
  const AdSubmissionDialog({super.key, required this.userId, required this.supabase});

  @override
  State<AdSubmissionDialog> createState() => _AdSubmissionDialogState();
}

class _AdSubmissionDialogState extends State<AdSubmissionDialog> {
  final _descCtrl = TextEditingController();
  final _imgCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("🚀 Propose ton annonce Sigma"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Envoie une image, une description et gagne des coins !", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 15),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _imgCtrl, decoration: const InputDecoration(labelText: "Lien de l'image (URL)", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _linkCtrl, decoration: const InputDecoration(labelText: "Lien externe", border: OutlineInputBorder())),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading ? const CircularProgressIndicator(strokeWidth: 2) : const Text("Soumettre"),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (_descCtrl.text.isEmpty || _imgCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.supabase.submitUserAd(widget.userId, _descCtrl.text, _imgCtrl.text, _linkCtrl.text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Soumission envoyée ! Attend la validation de l'admin pour tes coins.")));
      }
    } catch (e) {
      debugPrint("❌ Ad Submission Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
