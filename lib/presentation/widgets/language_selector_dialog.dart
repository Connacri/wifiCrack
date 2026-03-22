import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale = localeProvider.locale ?? Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    final languages = [
      {'name': 'English', 'code': 'en', 'flag': '🇺🇸'},
      {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
      {'name': 'العربية', 'code': 'ar', 'flag': '🇩🇿'},
      {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
      {'name': '中文', 'code': 'zh', 'flag': '🇨🇳'},
      {'name': '日本語', 'code': 'ja', 'flag': '🇯🇵'},
      {'name': 'Русский', 'code': 'ru', 'flag': '🇷🇺'},
      {'name': 'Português', 'code': 'pt', 'flag': '🇧🇷'},
      {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
      {'name': 'Bahasa Indonesia', 'code': 'id', 'flag': '🇮🇩'},
    ];

    return AlertDialog(
      title: Text(l10n.languageSelectorTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            final isSelected = currentLocale.languageCode == lang['code'];

            return ListTile(
              leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
              title: Text(lang['name']!),
              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                localeProvider.setLocale(Locale(lang['code']!));
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
