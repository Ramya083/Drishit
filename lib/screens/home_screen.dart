// lib/screens/home_screen.dart
//
// Main screen UI: large "Start Listening" button, camera preview, capture button,
// and a readout area for spoken output.
//
// This screen coordinates CameraService, AIService, and TTSService.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/camera_service.dart';
import '../services/ai_service.dart';
import '../services/tts_service.dart';
import '../utils/accessibility.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraService _cameraService;
  final AIService _aiService = AIService();
  final TTSService _ttsService = TTSService();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String _spokenText = '';
  bool _isListening = false;
  String _listeningStatus = 'Not Listening';

  @override
  void initState() {
    super.initState();
    // Initialize camera service with the first available camera (usually back camera)
    final camera = widget.cameras.isNotEmpty ? widget.cameras.first : null;
    _cameraService = CameraService(cameraDescription: camera);
    _cameraService.initialize().then((_) {
      if (mounted) setState(() {});
    });

    // Initialize TTS
    _ttsService.init();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          // Update listening status for accessibility
          setState(() {
            _listeningStatus = val;
          });
        },
        onError: (val) {
          setState(() {
            _listeningStatus = 'Error: ${val.errorMsg}';
          });
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _listeningStatus = 'Listening... (speak now)';
        });
        _speech.listen(onResult: (result) {
          if (result.finalResult) {
            final recognized = result.recognizedWords.toLowerCase();
            setState(() {
              _spokenText = 'Heard: ${result.recognizedWords}';
            });

            // Simple demo: if user says "capture" or "take photo", trigger capture
            if (recognized.contains('capture') ||
                recognized.contains('take') && recognized.contains('photo') ||
                recognized.contains('drishti')) {
              // perform capture
              _onCapturePressed();
            }
          }
        });
      } else {
        setState(() {
          _listeningStatus = 'Speech recognition unavailable';
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
        _listeningStatus = 'Not Listening';
      });
    }
  }

  Future<void> _onCapturePressed() async {
    if (!_cameraService.isInitialized) {
      setState(() {
        _spokenText = 'Camera not initialized';
      });
      return;
    }

    setState(() {
      _spokenText = 'Capturing image...';
    });

    try {
      final XFile? file = await _cameraService.takePicture();
      if (file == null) {
        setState(() {
          _spokenText = 'Failed to capture image.';
        });
        return;
      }

      setState(() {
        _spokenText = 'Analyzing image...';
      });

      // Analyze the image (placeholder AI service)
      final String description = await _aiService.analyzeImage(File(file.path));

      // Update UI and speak description
      setState(() {
        _spokenText = description;
      });

      await _ttsService.speak(description);
    } catch (e) {
      setState(() {
        _spokenText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _cameraService.buildPreview();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drishti'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Big Start Listening button (simulates voice wake)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _toggleListening,
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 28),
                label: Text(_isListening ? 'Stop Listening' : 'Start Listening', style: Accessibility.largeButtonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(64),
                ),
              ),
            ),

            // Listening status (clear and large)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(_listeningStatus, style: Accessibility.statusText, textAlign: TextAlign.center),
            ),

            const SizedBox(height: 12),

            // Camera preview area - accessible, takes a majority of the screen
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow[700]!, width: 3),
                  color: Colors.black,
                ),
                child: preview ??
                    Center(
                      child: Text('Camera not available', style: Accessibility.largeText),
                    ),
              ),
            ),

            // Capture button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: _onCapturePressed,
                icon: const Icon(Icons.camera_alt, size: 28),
                label: const Text('Capture Image', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(64),
                ),
              ),
            ),

            // Spoken output (readable and large)
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Text(
                _spokenText.isNotEmpty ? _spokenText : 'Spoken output will appear here.',
                style: Accessibility.outputText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
