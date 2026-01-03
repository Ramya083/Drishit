# Drishti — Voice-Activated AI Vision Assistant (Flutter)

Drishti is a minimal, high-contrast Flutter mobile app prototype that simulates a voice-activated AI vision assistant for visually impaired users.

Core features:
- Voice wake command simulation via a large "Start Listening" button (ready to be replaced by a hotword detector).
- Camera preview and capture (uses device camera).
- Placeholder AI image analysis (local simulation; shows how to integrate real API).
- Human-friendly description generation for detected objects.
- Spoken output using Text-to-Speech (flutter_tts).
- Large, high-contrast UI for accessibility.

This project is a pure Flutter app intended to run on Android devices (Android Studio). It uses:
- camera
- speech_to_text
- flutter_tts
- http

Files included:
- pubspec.yaml
- lib/main.dart
- lib/screens/home_screen.dart
- lib/services/camera_service.dart
- lib/services/ai_service.dart
- lib/services/tts_service.dart
- lib/utils/accessibility.dart

Setup & Run (Android)
1. Install Flutter (latest stable) and Android Studio. Ensure Flutter and Android SDK are configured.
   - https://flutter.dev/docs/get-started/install

2. Clone or copy project into your workstation.

3. Update Android permissions:

   Add the following to `android/app/src/main/AndroidManifest.xml` inside the `<manifest>` block:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.RECORD_AUDIO"/>
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

   And ensure the camera permission is handled at runtime (the app requests permission).

4. If targeting Android 11+, add camera provider flags or ensure correct usage in manifest (typical Flutter camera plugin docs cover this).

5. From the project folder run:
   ```
   flutter pub get
   flutter run
   ```

6. Open in Android Studio:
   - File -> Open -> select project folder
   - Let Android Studio fetch dependencies, then run on an emulator or physical device with camera.

Notes and Integration
- AI analysis in this template is a placeholder. See lib/services/ai_service.dart for commented example showing how to send the captured image bytes to a real HTTP/AI endpoint.
- The "Start Listening" button uses speech_to_text to demonstrate integration and future readiness; currently the actual wake-word detection ("Hey Drishti") is simulated by pressing the button.
- The UI is intentionally minimal and high-contrast for accessibility.

If you'd like, I can provide example server code or help integrate a real vision backend.
