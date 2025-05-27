import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A circular dial widget that displays the timer
class TimerDial extends StatelessWidget {
  /// Duration in seconds
  final int duration;

  /// Progress value from 0.0 to 1.0
  final double progress;

  /// Color of the timer dial
  final Color color;

  /// Whether the timer is currently running
  final bool isRunning;

  /// Default constructor for TimerDial
  const TimerDial({
    super.key,
    required this.duration,
    required this.progress,
    required this.color,
    required this.isRunning,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A), // Slightly lighter than black
              border: Border.all(color: color.withValues(alpha: 0.2), width: 3),
            ),
          ),

          // Progress indicator
          SizedBox(
            width: 280,
            height: 280,
            child: CustomPaint(
              painter: _TimerDialPainter(
                progress: progress,
                color: color,
                strokeWidth: 8,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(
                duration: const Duration(seconds: 4),
                color: color.withValues(alpha: 0.1),
              ),

          // Timer value
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer text
              Text(
                _formatDuration(duration),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),

              const SizedBox(height: 8),

              // Pause/play indicator
              Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                color: color.withValues(alpha: 0.8),
                size: 36,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                    target: isRunning ? 0.0 : 1.0,
                  )
                  .fade(
                    duration: const Duration(milliseconds: 800),
                    begin: 0.6,
                    end: 1.0,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerDialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _TimerDialPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2; // Start from top (12 o'clock position)
    final sweepAngle = 2 * pi * progress;

    // Draw background arc (full circle with lower opacity)
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 2
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.1);

    canvas.drawArc(rect, 0, 2 * pi, false, backgroundPaint);

    // Draw progress arc
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_TimerDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
