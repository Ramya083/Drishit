// lib/utils/accessibility.dart
//
// Accessibility helpers: centralized text styles for large text and contrast-friendly styles.

import 'package:flutter/material.dart';

class Accessibility {
  static const TextStyle largeButtonText = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle largeText = TextStyle(fontSize: 18, color: Colors.white);
  static const TextStyle statusText = TextStyle(fontSize: 16, color: Colors.white70);
  static const TextStyle outputText = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);
}
