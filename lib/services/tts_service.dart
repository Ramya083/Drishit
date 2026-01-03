// lib/services/tts_service.dart
//
// Simple wrapper around flutter_tts. Initializes voice parameters and exposes speak().
// The service will be used to read aloud descriptions for the user.

import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> init() async {
    // Optionally set language and speech rate for clarity.
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45); // slower for clarity
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
