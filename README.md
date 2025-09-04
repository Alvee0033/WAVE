# WAVE - AI-Powered World Analysis & Visualization Engine

A Flutter application for visualizing NASA satellite data and Earth observations with an interactive 3D globe interface.

## Features

- **Interactive 3D Globe**: Explore Earth with gesture controls and data layer overlays
- **NASA Instrument Data**: Visualize data from MODIS, ASTER, MISR, CERES, and MOPITT instruments
- **Timeline Control**: Navigate through years of satellite data with playback controls
- **Region Details**: Detailed views of specific regions with satellite imagery and data stories
- **Responsive Design**: Optimized for mobile, tablet, and desktop screens
- **Dark Theme**: Modern UI with NASA-inspired color scheme

## Prerequisites

Before running this application, ensure you have:

1. **Flutter SDK** (3.35.2 or later)
2. **Android Studio** with Android SDK
3. **Android device or emulator** for testing

## Setup Instructions

### 1. Install Flutter

If you haven't installed Flutter yet:

1. Download Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Extract and add Flutter to your PATH
3. Run `flutter doctor` to verify installation

### 2. Setup Android Development

1. **Install Android Studio**:
   - Download from [developer.android.com/studio](https://developer.android.com/studio)
   - Install with default settings

2. **Configure Android SDK**:
   - Open Android Studio
   - Go to Tools > SDK Manager
   - Install the latest Android SDK and build tools

3. **Setup Android Emulator** (optional):
   - In Android Studio, go to Tools > AVD Manager
   - Create a new virtual device
   - Choose a device definition and system image
   - Start the emulator

### 3. Install Dependencies

```bash
cd nasa
flutter pub get
```

### 4. Run the Application

#### On Android Device:
1. Enable Developer Options and USB Debugging on your device
2. Connect your device via USB
3. Run:
```bash
flutter run
```

#### On Android Emulator:
1. Start your Android emulator
2. Run:
```bash
flutter run
```

#### For Web (Development):
```bash
flutter run -d chrome
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/
│   └── app_state.dart       # Global state management
├── screens/
│   ├── splash_screen.dart   # Splash screen with animations
│   ├── main_dashboard.dart  # Main dashboard with globe
│   └── region_details.dart  # Region detail pages
├── widgets/
│   ├── globe_widget.dart    # Interactive 3D globe
│   ├── timeline_slider.dart # Timeline controls
│   ├── data_layers_panel.dart # Data layer controls
│   ├── story_card.dart      # Data story cards
│   └── orbital_loading_animation.dart # Loading animations
├── theme/
│   ├── app_theme.dart       # App theming
│   └── app_constants.dart   # Design constants
├── services/
│   └── navigation_service.dart # Navigation utilities
└── utils/
    └── responsive_helper.dart # Responsive design utilities
```

## Key Dependencies

- **flutter_map**: Interactive maps and geospatial visualization
- **provider**: State management
- **go_router**: Navigation and routing
- **lottie**: Animations
- **three_dart**: 3D graphics (planned)
- **http**: API communication
- **shared_preferences**: Local data storage

## Development

### Running Tests

```bash
flutter test
```

### Building for Release

#### Android APK:
```bash
flutter build apk --release
```

#### Android App Bundle:
```bash
flutter build appbundle --release
```

### Code Analysis

```bash
flutter analyze
```

## Troubleshooting

### Common Issues

1. **Android SDK not found**:
   - Run `flutter doctor` to check setup
   - Install Android Studio and SDK
   - Run `flutter config --android-sdk <path-to-sdk>`

2. **Dependency conflicts**:
   - Run `flutter pub deps` to check dependencies
   - Update pubspec.yaml versions if needed
   - Run `flutter clean && flutter pub get`

3. **Build errors**:
   - Ensure all dependencies are compatible
   - Check Flutter and Dart SDK versions
   - Clear build cache: `flutter clean`

### Performance Tips

- Use `flutter run --profile` for performance testing
- Enable GPU rendering for better graphics performance
- Test on physical devices for accurate performance metrics

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- NASA for providing satellite data and imagery
- Flutter team for the excellent framework
- Open source community for the amazing packages used