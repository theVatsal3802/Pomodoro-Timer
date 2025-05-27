import 'dart:async';

import 'package:flutter/material.dart';

/// Enum representing different timer modes
enum TimerMode {
  /// Focus session mode
  focus,

  /// Short break mode
  shortBreak,

  /// Long break mode
  longBreak,
}

/// Model class for managing the Pomodoro timer state and logic
class TimerModel extends ChangeNotifier {
  /// Default constructor for TimerModel
  TimerModel() {
    _remainingDuration = _focusDuration;
  }

  // Timer settings with default values
  int _focusDuration = 25 * 60; // 25 minutes in seconds
  int _shortBreakDuration = 5 * 60; // 5 minutes in seconds
  int _longBreakDuration = 15 * 60; // 15 minutes in seconds
  int _sessionsBeforeLongBreak = 4;

  // Current state
  Timer? _timer;
  TimerMode _currentMode = TimerMode.focus;
  int _remainingDuration = 0;
  int _completedSessions = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  // For preventing duplicate notifications
  bool _isTransitioning = false;

  /// Current timer mode (focus, short break, or long break)
  TimerMode get currentMode => _currentMode;

  /// Remaining duration in seconds
  int get remainingDuration => _remainingDuration;

  /// Total duration based on current mode
  int get totalDuration {
    switch (_currentMode) {
      case TimerMode.focus:
        return _focusDuration;
      case TimerMode.shortBreak:
        return _shortBreakDuration;
      case TimerMode.longBreak:
        return _longBreakDuration;
    }
  }

  /// Number of completed sessions
  int get completedSessions => _completedSessions;

  /// Number of sessions before a long break
  int get sessionsBeforeLongBreak => _sessionsBeforeLongBreak;

  /// Indicates if the timer is currently running
  bool get isRunning => _isRunning;

  /// Indicates if the timer is paused
  bool get isPaused => _isPaused;

  /// Focus duration in seconds
  int get focusDuration => _focusDuration;

  /// Short break duration in seconds
  int get shortBreakDuration => _shortBreakDuration;

  /// Long break duration in seconds
  int get longBreakDuration => _longBreakDuration;

  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (totalDuration == 0) return 0.0; // Prevent division by zero
    return 1.0 - (_remainingDuration / totalDuration);
  }

  /// Set focus duration in minutes
  set focusDuration(int minutes) {
    _focusDuration = minutes * 60;
    if (_currentMode == TimerMode.focus && !_isRunning) {
      _remainingDuration = _focusDuration;
      notifyListeners();
    }
  }

  /// Set short break duration in minutes
  set shortBreakDuration(int minutes) {
    _shortBreakDuration = minutes * 60;
    if (_currentMode == TimerMode.shortBreak && !_isRunning) {
      _remainingDuration = _shortBreakDuration;
      notifyListeners();
    }
  }

  /// Set long break duration in minutes
  set longBreakDuration(int minutes) {
    _longBreakDuration = minutes * 60;
    if (_currentMode == TimerMode.longBreak && !_isRunning) {
      _remainingDuration = _longBreakDuration;
      notifyListeners();
    }
  }

  /// Set number of sessions before a long break
  set sessionsBeforeLongBreak(int sessions) {
    _sessionsBeforeLongBreak = sessions;
    notifyListeners();
  }

  /// Start the timer
  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _isPaused = false;

    _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
    notifyListeners();
  }

  /// Pause the timer
  void pause() {
    if (!_isRunning) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = true;
    notifyListeners();
  }

  /// Resume the timer
  void resume() {
    if (!_isPaused) return;

    start();
  }

  /// Reset the timer based on the current mode
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _isTransitioning = false;

    switch (_currentMode) {
      case TimerMode.focus:
        _remainingDuration = _focusDuration;
      case TimerMode.shortBreak:
        _remainingDuration = _shortBreakDuration;
      case TimerMode.longBreak:
        _remainingDuration = _longBreakDuration;
    }

    notifyListeners();
  }

  /// Stop the timer and reset everything
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    _isTransitioning = false;
    _currentMode = TimerMode.focus;
    _remainingDuration = _focusDuration;
    _completedSessions = 0;

    notifyListeners();
  }

  /// Toggle between pause and resume
  void togglePause() {
    if (_isRunning) {
      pause();
    } else if (_isPaused) {
      resume();
    }
  }

  /// Timer tick callback
  void _timerCallback(Timer timer) {
    if (_remainingDuration <= 0) {
      _timer?.cancel();
      _timer = null;
      _isRunning = false;
      _onTimerComplete();
      return;
    }

    _remainingDuration--;
    notifyListeners();
  }

  /// Handle timer completion and mode transitions
  void _onTimerComplete() {
    // Set transitioning flag to true to prevent duplicate notifications
    _isTransitioning = true;

    // Store previous mode for reference
    final previousMode = _currentMode;

    switch (_currentMode) {
      case TimerMode.focus:
        _completedSessions++;
        if (_completedSessions % _sessionsBeforeLongBreak == 0) {
          _currentMode = TimerMode.longBreak;
          _remainingDuration = _longBreakDuration;
        } else {
          _currentMode = TimerMode.shortBreak;
          _remainingDuration = _shortBreakDuration;
        }
      case TimerMode.shortBreak:
      case TimerMode.longBreak:
        _currentMode = TimerMode.focus;
        _remainingDuration = _focusDuration;
    }

    // Only notify if there's an actual mode change
    if (previousMode != _currentMode) {
      notifyListeners();
    }

    // Reset transitioning flag
    _isTransitioning = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
