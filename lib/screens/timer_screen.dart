import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/models/timer_model.dart';
import 'package:pomodoro/routes/app_router.dart';
import 'package:pomodoro/theme/app_theme.dart';
import 'package:pomodoro/widgets/timer_dial.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

/// Screen that displays the timer during active sessions
class TimerScreen extends StatefulWidget {
  /// Default constructor for TimerScreen
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _lastTapTime = 0;
  bool _isExitDialogShowing = false;
  TimerMode _lastMode = TimerMode.focus;

  @override
  void initState() {
    super.initState();

    // Enable wakelock to prevent screen from sleeping
    Wakelock.enable();

    // Start the timer when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final timerModel = Provider.of<TimerModel>(context, listen: false);
      timerModel.start();
      _lastMode = timerModel.currentMode;

      // Listen for timer mode changes to play sound
      timerModel.addListener(_onTimerModelChanged);
    });
  }

  @override
  void dispose() {
    // Disable wakelock when leaving the screen
    Wakelock.disable();

    // Check mounted state before accessing context to avoid the deactivated widget error
    if (mounted) {
      final timerModel = Provider.of<TimerModel>(context, listen: false);
      timerModel.removeListener(_onTimerModelChanged);
    }

    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTimerModelChanged() {
    if (!mounted) return;

    // This listener will be called whenever the timer model changes
    // We want to play a sound when the mode changes
    final timerModel = Provider.of<TimerModel>(context, listen: false);

    // Check if the mode has changed (rather than just checking remainingDuration)
    final currentMode = timerModel.currentMode;
    if (currentMode != _lastMode &&
        timerModel.remainingDuration == timerModel.totalDuration) {
      _playAlertSound(currentMode);
      _lastMode = currentMode;
    }
  }

  Future<void> _playAlertSound(TimerMode mode) async {
    try {
      // Play sound from assets
      await _audioPlayer.play(AssetSource('sounds/alert.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');

      // Show fallback notification if sound fails - safely check mounted state
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alert: Mode changed to ${_getModeText(mode)}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleTap() {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (_isExitDialogShowing) {
      return;
    }

    if (now - _lastTapTime < 300) {
      // Double tap detected
      _showExitConfirmationDialog();
    } else {
      // Single tap - toggle pause/resume
      final timerModel = Provider.of<TimerModel>(context, listen: false);
      timerModel.togglePause();
    }

    _lastTapTime = now;
  }

  void _showExitConfirmationDialog() {
    setState(() {
      _isExitDialogShowing = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (BuildContext dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Exit Timer?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to exit the timer? Your progress will be reset.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog using the dialog's context
                  Navigator.of(dialogContext).pop();

                  if (mounted) {
                    setState(() {
                      _isExitDialogShowing = false;
                    });
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog using the dialog's context
                  Navigator.of(dialogContext).pop();

                  // Get the timer model and stop it
                  if (mounted) {
                    final timerModel = Provider.of<TimerModel>(
                      context,
                      listen: false,
                    );
                    timerModel.stop();

                    // Navigate using the main context
                    context.go(AppRoutes.timeSelection);

                    setState(() {
                      _isExitDialogShowing = false;
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.focusColor,
                ),
                child: const Text('Yes'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 24,
          ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isExitDialogShowing = false;
        });
      }
    });
  }

  Color _getModeColor(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return AppTheme.focusColor;
      case TimerMode.shortBreak:
        return AppTheme.shortBreakColor;
      case TimerMode.longBreak:
        return AppTheme.longBreakColor;
    }
  }

  String _getModeText(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return 'Focus';
      case TimerMode.shortBreak:
        return 'Short Break';
      case TimerMode.longBreak:
        return 'Long Break';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerModel>(
      builder: (context, timerModel, child) {
        final mode = timerModel.currentMode;
        final color = _getModeColor(mode);

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _handleTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Current Mode Text
                      Text(
                        _getModeText(mode),
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(color: color),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                      ),

                      const SizedBox(height: 16),

                      // Session Counter
                      Text(
                        'Session ${timerModel.completedSessions + 1} of ${timerModel.sessionsBeforeLongBreak}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 600),
                      ),

                      const SizedBox(height: 48),

                      // Timer Dial
                      Center(
                        child: TimerDial(
                          duration: timerModel.remainingDuration,
                          progress: timerModel.progress,
                          color: color,
                          isRunning: timerModel.isRunning,
                        ),
                      ).animate().scale(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                      ),

                      const SizedBox(height: 48),

                      // Tap Instructions
                      Text(
                        timerModel.isRunning
                            ? 'Tap once to pause'
                            : 'Tap once to resume',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 800),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Double tap to exit',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1000),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
