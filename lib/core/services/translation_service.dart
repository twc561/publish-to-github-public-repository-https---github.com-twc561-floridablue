import 'package:flutter/foundation.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'dart:developer';

class TranslationService {
  final _english = TranslateLanguage.english;
  OnDeviceTranslator? _translator;

  // Manages the state of language model downloads
  final ValueNotifier<bool> isSpanishModelDownloaded = ValueNotifier(false);
  final ValueNotifier<bool> isFrenchModelDownloaded = ValueNotifier(false);

  TranslationService() {
    _checkModelDownloads();
  }
  
  void dispose() {
    isSpanishModelDownloaded.dispose();
    isFrenchModelDownloaded.dispose();
    _translator?.close(); // Safely close the translator if it exists
  }

  /// Returns the BCP-47 language code as a string for a given TranslateLanguage.
  String _getBcp47Code(TranslateLanguage language) {
    switch (language) {
      case TranslateLanguage.spanish:
        return 'es';
      case TranslateLanguage.french:
        return 'fr';
      // Add other language codes here as you support them
      default:
        return 'en';
    }
  }

  /// Checks which language models are already downloaded on the device.
  Future<void> _checkModelDownloads() async {
    final modelManager = OnDeviceTranslatorModelManager();
    isSpanishModelDownloaded.value = await modelManager.isModelDownloaded(_getBcp47Code(TranslateLanguage.spanish));
    isFrenchModelDownloaded.value = await modelManager.isModelDownloaded(_getBcp47Code(TranslateLanguage.french));
  }

  /// Downloads a language model if it's not already present.
  Future<void> downloadModel(TranslateLanguage language, ValueNotifier<bool> notifier) async {
    final modelManager = OnDeviceTranslatorModelManager();
    final bcp47Code = _getBcp47Code(language);

    if (await modelManager.isModelDownloaded(bcp47Code)) {
      notifier.value = true;
      return;
    }
    
    log("Downloading ${language.name} model...");
    await modelManager.downloadModel(bcp47Code);
    notifier.value = true;
    log("${language.name} model downloaded.");
  }

  /// Translates the given text to the specified language.
  Future<String> translate(String text, TranslateLanguage targetLanguage) async {
    if (targetLanguage == _english) {
      return text;
    }

    // Initialize the translator for the correct language pair
    _translator = OnDeviceTranslator(sourceLanguage: _english, targetLanguage: targetLanguage);
    
    try {
      return await _translator!.translateText(text);
    } catch (e) {
      log('Error translating text: $e');
      return 'Translation failed. Please ensure the language model is downloaded.';
    }
  }
}
