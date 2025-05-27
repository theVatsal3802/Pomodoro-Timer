# Pomodoro Timer App

A Pomodoro timer application built with Flutter that helps users manage work sessions with breaks using the Pomodoro Technique.

## Features

- Dark theme UI
- Customizable focus, short break, and long break durations
- Adjustable number of sessions before long break
- Visual timer with progress indicator
- Interactive controls with tap gestures
- Session tracking
- Auto-transitions between modes

## Project Structure

```md
lib/
├── models/ # Data models
├── routes/ # Routing configuration
├── screens/ # App screens
├── services/ # Business logic services
├── theme/ # Theme configuration
├── widgets/ # Reusable UI components
└── main.dart # App entry point
```

## Getting Started

1. Ensure Flutter is installed on your system
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. To run the app: `flutter run`

## Note for Deployment

Before deploying this app, you would need to:

1. Add sound alert files in the `assets/sounds/` directory

   - Create or download an MP3 file named `alert.mp3` to play during mode transitions
   - Update the `AudioService` to use the actual sound file

2. Test thoroughly on real devices
   - Ensure wakelock functionality works properly
   - Verify sound alerts play correctly
   - Test various device sizes and orientations

## Implementation Details

This app follows the Pomodoro Technique with:

- Focus sessions (default 25 minutes)
- Short breaks (default 5 minutes)
- Long breaks (default 15 minutes) after a set number of sessions
- Automatic transitions between modes

Interface allows for:

- Single tap to pause/resume
- Double tap to exit (with confirmation)
