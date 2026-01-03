// lib/services/camera_service.dart
//
// Camera helper service: initializes CameraController, exposes preview widget and capture method.
// The service uses the camera package and handles lifecycle/disposing.
//
// Note: Camera permissions must be requested by the app (AndroidManifest + runtime).

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraService {
  final CameraDescription? cameraDescription;
  CameraController? _controller;

  CameraService({required this.cameraDescription});

  bool get isInitialized => _controller?.value.isInitialized ?? false;

  Future<void> initialize() async {
    if (cameraDescription == null) return;
    _controller = CameraController(
      cameraDescription!,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // Initialize the controller
    await _controller!.initialize();
    // Optionally set additional parameters:
    // await _controller!.setFlashMode(FlashMode.off);
  }

  // Builds a camera preview widget to include in the UI.
  Widget? buildPreview() {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CameraPreview(_controller!),
    );
  }

  // Capture an image and return the XFile
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    if (_controller!.value.isTakingPicture) {
      // A capture is already pending, ignore or wait
      return null;
    }

    try {
      final XFile file = await _controller!.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('CameraException while taking picture: ${e.code} - ${e.description}');
      return null;
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}
