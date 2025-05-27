import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/models/timer_model.dart';
import 'package:pomodoro/routes/app_router.dart';
import 'package:provider/provider.dart';

/// Screen for selecting timer durations
class TimeSelectionScreen extends StatefulWidget {
  /// Default constructor for TimeSelectionScreen
  const TimeSelectionScreen({super.key});

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  bool _isNavigating = false;

  void _navigateTo(String route) {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Set Timer'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Focus Duration Selection
              _buildDurationSelector(
                context: context,
                title: 'Focus Duration',
                value: timerModel.focusDuration ~/ 60,
                onChanged: (value) {
                  timerModel.focusDuration = value;
                },
                options: const [25, 30, 45, 60],
                icon: Icons.work,
                color: Theme.of(context).colorScheme.primary,
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 100),
              ),

              const SizedBox(height: 24),

              // Short Break Duration Selection
              _buildDurationSelector(
                context: context,
                title: 'Short Break Duration',
                value: timerModel.shortBreakDuration ~/ 60,
                onChanged: (value) {
                  timerModel.shortBreakDuration = value;
                },
                options: const [5, 10, 15],
                icon: Icons.coffee,
                color: Theme.of(context).colorScheme.secondary,
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 200),
              ),

              const SizedBox(height: 24),

              // Long Break Duration Selection
              _buildDurationSelector(
                context: context,
                title: 'Long Break Duration',
                value: timerModel.longBreakDuration ~/ 60,
                onChanged: (value) {
                  timerModel.longBreakDuration = value;
                },
                options: const [15, 20, 30],
                icon: Icons.self_improvement,
                color: const Color(0xFF408EC6),
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 300),
              ),

              const SizedBox(height: 24),

              // Sessions Before Long Break
              _buildDurationSelector(
                context: context,
                title: 'Sessions Before Long Break',
                value: timerModel.sessionsBeforeLongBreak,
                onChanged: (value) {
                  timerModel.sessionsBeforeLongBreak = value;
                },
                options: const [2, 3, 4, 5, 6],
                icon: Icons.repeat,
                color: Colors.purpleAccent,
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 400),
              ),

              const Spacer(),

              // Tutorial Button
              TextButton.icon(
                onPressed: () {
                  _navigateTo(AppRoutes.tutorial);
                },
                icon: const Icon(Icons.help_outline),
                label: const Text('How to use'),
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
              ).animate().fadeIn(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 500),
              ),

              const SizedBox(height: 16),

              // Start Button
              ElevatedButton(
                    onPressed: () {
                      _navigateTo(AppRoutes.timer);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'START',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    duration: const Duration(milliseconds: 300),
                    delay: const Duration(milliseconds: 500),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .shimmer(
                    duration: const Duration(seconds: 2),
                    color: Colors.white24,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelector({
    required BuildContext context,
    required String title,
    required int value,
    required Function(int) onChanged,
    required List<int> options,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: options.contains(value) ? value : options.first,
              items:
                  options.map((option) {
                    return DropdownMenuItem<int>(
                      value: option,
                      child: Text(
                        title.contains('Duration')
                            ? '$option minutes'
                            : option.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              dropdownColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
