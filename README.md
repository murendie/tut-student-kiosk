# TUT Student Kiosk Application

A modern and interactive kiosk application for TUT students.

## Features

- Interactive splash screen with animations
- Modern UI with smooth transitions
- Grid-based menu system
- Consistent color scheme using TUT brand colors
- Responsive design for various screen sizes

## Project Structure

```
tut-student-kiosk/
├── lib/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   └── home_page.dart
│   ├── widgets/
│   │   ├── grid_item.dart
│   │   └── top_bar.dart
│   └── main.dart
├── images/
│   ├── logo_top.png
│   └── logo_nav.png
├── fonts/
│   ├── Ruda-Regular.ttf
│   └── Ruda-Bold.ttf
└── pubspec.yaml
```

## Setup Instructions

1. Make sure you have Flutter installed on your system
2. Clone this repository
3. Place the required assets:
   - Add logo images to the `images/` directory
   - Add Ruda font files to the `fonts/` directory
4. Run `flutter pub get` to install dependencies
5. Run `flutter run` to start the application

## Color Scheme

- Primary Blue: #005496
- Secondary Red: #E41936
- Accent Yellow: #F9BC0A
- Background: #F6F9FF
- White: #FFFFFF
- Black: #000000

## Dependencies

- Flutter SDK: >=3.0.0 <4.0.0
- cupertino_icons: ^1.0.2

## Development

This project follows Flutter best practices and uses Material Design 3 components. The UI is built with a focus on smooth animations and transitions for a better user experience.
