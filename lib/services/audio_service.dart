import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Service for handling audio playback in the app
class AudioService {
  static final AudioService _instance = AudioService._internal();

  /// Factory constructor for singleton pattern
  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Play alert sound for timer transitions
  Future<void> playAlertSound() async {
    try {
      // Note: In a real app, you would need to add a sound file at assets/sounds/alert.mp3
      // For now, we're not actually playing any sound
      debugPrint('🔔 Timer mode changed - alert sound would play here');

      // Uncomment when sound file is available
      // await _player.play(AssetSource('sounds/alert.mp3'));
    } catch (e) {
      debugPrint('Error playing alert sound: $e');
    }
  }

  /// Show alert notification when sound can't be played
  void showAlertNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
  }
}
