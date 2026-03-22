import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../data/sources/supabase_service.dart';
import '../../data/sources/ad_service.dart';

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
                          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
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
  bool _rewarded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.sigmaAdProposalTitle),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(l10n.submitAdInfo, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 15),
            TextField(controller: _descCtrl, decoration: InputDecoration(labelText: l10n.descriptionLabel, border: const OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _imgCtrl, decoration: InputDecoration(labelText: l10n.imageLinkUrl, border: const OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _linkCtrl, decoration: InputDecoration(labelText: l10n.externalLink, border: const OutlineInputBorder())),
            const SizedBox(height: 20),
            _buildRewardSection(l10n),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading ? const CircularProgressIndicator(strokeWidth: 2) : Text(l10n.submit),
        ),
      ],
    );
  }

  Widget _buildRewardSection(AppLocalizations l10n) {
    if (_rewarded) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.bonusAddedText, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))),
          ],
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _showRewardedAd,
      icon: const Icon(Icons.play_circle_fill, color: Colors.orange),
      label: Text(l10n.watchVideoBonus, style: const TextStyle(fontSize: 11)),
    );
  }

  void _showRewardedAd() {
    context.read<AdService>().showRewardedAd(
      () => setState(() => _rewarded = true), // Reward earned
      () {}, // Ad closed
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_descCtrl.text.isEmpty || _imgCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.supabase.submitUserAd(widget.userId, _descCtrl.text, _imgCtrl.text, _linkCtrl.text);
      if (_rewarded) {
        await widget.supabase.addCoins(widget.userId, 50);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.submitAdSuccess)));
      }
    } catch (e) {
      debugPrint("❌ Ad Submission Error: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

