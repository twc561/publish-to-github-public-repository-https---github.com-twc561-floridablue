import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../../../core/services/translation_service.dart';

class MirandaWarningScreen extends StatefulWidget {
  const MirandaWarningScreen({super.key});

  @override
  State<MirandaWarningScreen> createState() => _MirandaWarningScreenState();
}

class _MirandaWarningScreenState extends State<MirandaWarningScreen> {
  final _translationService = TranslationService();
  
  // Define the languages you want to support
  final Map<String, TranslateLanguage> _supportedLanguages = {
    'English': TranslateLanguage.english,
    'Spanish': TranslateLanguage.spanish,
    'French': TranslateLanguage.french,
    // Add more languages here e.g., 'Haitian Creole': TranslateLanguage.haitianCreole,
  };
  
  late TranslateLanguage _selectedLanguage;
  String _translatedWarning = _mirandaWarningEnglish;
  bool _isTranslating = false;

  static const String _mirandaWarningEnglish = 
      "You have the right to remain silent.\n\n"
      "Anything you say can and will be used against you in a court of law.\n\n"
      "You have the right to an attorney.\n\n"
      "If you cannot afford an attorney, one will be provided for you.\n\n"
      "Do you understand the rights I have just read to you? With these rights in mind, do you wish to speak to me?";

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _supportedLanguages['English']!;
  }

  @override
  void dispose() {
    _translationService.dispose();
    super.dispose();
  }

  Future<void> _onLanguageChanged(TranslateLanguage? newLanguage) async {
    if (newLanguage == null || newLanguage == _selectedLanguage) return;

    setState(() {
      _selectedLanguage = newLanguage;
      _isTranslating = true;
    });

    // Determine which notifier to use based on the language
    final notifier = _getNotifierForLanguage(newLanguage);
    if (notifier != null && !notifier.value) {
      await _translationService.downloadModel(newLanguage, notifier);
    }
    
    final result = await _translationService.translate(_mirandaWarningEnglish, newLanguage);

    if (mounted) {
      setState(() {
        _translatedWarning = result;
        _isTranslating = false;
      });
    }
  }

  ValueNotifier<bool>? _getNotifierForLanguage(TranslateLanguage lang) {
    if (lang == TranslateLanguage.spanish) return _translationService.isSpanishModelDownloaded;
    if (lang == TranslateLanguage.french) return _translationService.isFrenchModelDownloaded;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Miranda Warning', style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _translatedWarning));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Warning copied to clipboard.')),
              );
            },
            tooltip: 'Copy Text',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildContextCard(theme),
          const SizedBox(height: 16),
          _buildTranslationCard(theme),
        ],
      ),
    );
  }

  Widget _buildContextCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'When to Read the Miranda Warning',
              style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            Text(
              'The Miranda Warning is required when two conditions are met:',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Custody'),
              subtitle: Text('The person is not free to leave.'),
            ),
            const ListTile(
              leading: Icon(Icons.question_answer_outlined),
              title: Text('Interrogation'),
              subtitle: Text('You are asking questions designed to elicit an incriminating response.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<TranslateLanguage>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
              ),
              items: _supportedLanguages.entries.map((entry) {
                final lang = entry.value;
                final notifier = _getNotifierForLanguage(lang);
                
                return DropdownMenuItem<TranslateLanguage>(
                  value: lang,
                  child: (notifier == null) // English has no model
                    ? Text(entry.key)
                    : ValueListenableBuilder<bool>(
                        valueListenable: notifier,
                        builder: (context, isDownloaded, child) {
                          return Row(
                            children: [
                              Text(entry.key),
                              if (!isDownloaded) ...[
                                const SizedBox(width: 8),
                                const Text('(requires download)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ],
                          );
                        },
                      ),
                );
              }).toList(),
              onChanged: _onLanguageChanged,
            ),
            const SizedBox(height: 24),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isTranslating
                  ? const CircularProgressIndicator()
                  : Text(
                      _translatedWarning,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 22, height: 1.5),
                      key: ValueKey(_translatedWarning), // Ensures animation triggers
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
