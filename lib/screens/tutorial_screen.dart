import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/routes/app_router.dart';

/// Tutorial screen that explains how to use the app
class TutorialScreen extends StatelessWidget {
  /// Default constructor for TutorialScreen
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.timeSelection),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTutorialSection(
                        context: context,
                        icon: Icons.timer_outlined,
                        title: 'The Pomodoro Technique',
                        content:
                            'The Pomodoro Technique is a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 100),
                      ),

                      const Divider(),

                      _buildTutorialSection(
                        context: context,
                        icon: Icons.settings,
                        title: 'Setting Up',
                        content:
                            'On the settings screen, select your desired durations for focus sessions, short breaks, and long breaks. You can also set how many focus sessions to complete before taking a long break.',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 200),
                      ),

                      const Divider(),

                      _buildTutorialSection(
                        context: context,
                        icon: Icons.touch_app,
                        title: 'Using the Timer',
                        content:
                            '• Single tap: Pause or resume the timer\n• Double tap: Show exit confirmation dialog\n\nThe timer will automatically transition between focus and break modes according to your settings.',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 300),
                      ),

                      const Divider(),

                      _buildTutorialSection(
                        context: context,
                        icon: Icons.notifications_active,
                        title: 'Alerts',
                        content:
                            'You will hear an alert sound when transitioning between focus and break modes.',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 400),
                      ),

                      const Divider(),

                      _buildTutorialSection(
                        context: context,
                        icon: Icons.phone_android,
                        title: 'Screen Wakelock',
                        content:
                            'Your screen will remain on during active timer sessions, so you can always see your progress at a glance.',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 500),
                      ),

                      const Divider(),

                      _buildTutorialSection(
                        context: context,
                        icon: Icons.tips_and_updates,
                        title: 'Tips for Success',
                        content:
                            '• Focus intensely during work sessions\n• Take breaks seriously - step away from your work\n• Use the long break to recharge\n• Keep your phone visible while the timer runs',
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 600),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(AppRoutes.timeSelection);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ).animate().fade(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(milliseconds: 600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(content, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
