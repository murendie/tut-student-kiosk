# TUT Student Kiosk Application

A modern and interactive kiosk application for TUT students, featuring animated interfaces and an intuitive navigation system.

## Latest Updates

### Visual Enhancements
- Added letter-by-letter animation to the welcome text
- Implemented spinning globe animation on the splash screen
- Refined text sizes and removed shadows for cleaner appearance
- Changed Wayfinder button color to sea green (#2E8B57)

### Layout Improvements
- Repositioned logo to top of splash screen
- Added responsive grid layout for main menu
- Optimized button spacing and sizing
- Improved overall visual hierarchy

## Features

### Splash Screen
- Static logo at the top
- Animated spinning globe in the center
- Smooth "Touch to Start" fade animation
- Clean black background for contrast

### Main Menu
- Animated "Welcome to TUT Kiosk" text (letter-by-letter animation)
- Streamlined secondary text "What would you like to do?"
- Four main options in a responsive grid:
  - EduBot (Yellow: #F9BC0A)
  - Study@TUT (Red: #E41936)
  - Pay (Blue: #005496)
  - Wayfinder (Sea Green: #2E8B57)

### Animations
1. Welcome Text Animation:
   - Individual letter scaling
   - Sequential animation with 50ms delays
   - Smooth fade in/out effects
   - Continuous loop with proper timing
   - Elastic animation curve for natural feel

2. Splash Screen Globe:
   - Continuous spinning animation
   - Pulsing grid overlay
   - Subtle glow effect
   - Responsive sizing

## Project Structure

```
tut-student-kiosk/
├── lib/
│   ├── screens/
│   │   ├── splash_screen.dart  # Splash screen with globe animation
│   │   └── home_page.dart      # Main menu with animated welcome
│   ├── widgets/
│   │   ├── animated_text.dart  # Custom letter animation widget
│   │   ├── grid_item.dart      # Responsive grid items
│   │   └── top_bar.dart        # Application top bar
│   └── main.dart               # Application entry point
├── images/
│   ├── logo_top.png           # Main logo for splash screen
│   └── logo_nav.png           # Navigation bar logo
├── fonts/
│   ├── Ruda-Regular.ttf
│   └── Ruda-Bold.ttf
└── pubspec.yaml               # Project configuration
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
- Wayfinder Green: #2E8B57
- Background: #F6F9FF
- Text Grey: #666666

## Dependencies

- Flutter SDK: >=3.0.0 <4.0.0
- cupertino_icons: ^1.0.2
- flutter_spinkit: ^5.2.0 (for globe animation)

## Development

This project follows Flutter best practices and uses Material Design 3 components. The UI is built with a focus on smooth animations and transitions for a better user experience.
