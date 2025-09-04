always build apk and install over adb after a task done
# 📘 Project Rules for AI IDE (Trea)

These rules guide the AI assistant to make the project **robust, secure, and error-free**.  
Follow them for all code generation and edits.

---

## 1. General Rules
- Always write **clean, readable, and well-structured code**.  
- Use **consistent naming conventions** (camelCase for variables, PascalCase for classes).  
- Add **comments** for all non-trivial logic.  
- Avoid duplicate code → **reuse existing functions** where possible.  

---

## 2. Error Handling
- Always validate inputs (no blind trust on user data).  
- Wrap risky operations in **try/catch (or try/except)** blocks.  
- Handle edge cases (null values, empty arrays, DB errors, etc.).  
- Never crash silently → provide **meaningful error messages**.  

---

## 3. Security
- Use **prepared statements** for database queries (prevent SQL injection).  
- Sanitize HTML/JS inputs to avoid **XSS attacks**.  
- Do not hardcode **API keys, passwords, or secrets** inside code.  
- Store sensitive data in **environment/config files**.  

---

## 4. Testing
- Every major function/module should include **test coverage**.  
- Use the appropriate testing framework (e.g., PyTest, PHPUnit, Jest).  
- Simulate **edge cases** and validate correct output.  
- Run all tests before finalizing code.  

---

## 5. Documentation
- Every file should have a **header comment** describing its purpose.  
- Document functions with:
  - Parameters  
  - Return values  
  - Example usage  
- Keep `README.md` updated with:
  - Installation steps  
  - Run/test instructions  

---

## 6. Git & Workflow
- Write **clear commit messages** (`fix:`, `feat:`, `docs:`, `test:`).  
- Commit **small, meaningful changes**.  
- Review AI-generated code before committing.  

---

## 7. AI-Specific Instructions
- Always generate **concise and consistent** code.  
- Prefer **clarity over complexity**.  
- Explain generated code when asked.  
- Do not skip error handling or validation.  

---

✅ By following these rules, the project will stay **maintainable, secure, and less error-prone**.


# WAVE Flutter App Build Rules & Guidelines - IDE Memory Reference

## Flutter Build Configuration

### pubspec.yaml - Essential Dependencies
```yaml
name: wave_app
description: AI-Powered World Analysis & Visualization Engine
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management - MANDATORY
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # UI & Animation - REQUIRED
  flutter_svg: ^2.0.7
  lottie: ^2.6.0
  shimmer: ^3.0.0
  
  # Data & Network - ESSENTIAL
  dio: ^5.3.2
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Storage - REQUIRED
  shared_preferences: ^2.2.0
  hive_flutter: ^1.1.0
  
  # Maps & Visualization - CORE
  mapbox_gl: ^0.16.0
  flutter_map: ^5.0.0
  fl_chart: ^0.63.0
  
  # Utils - MANDATORY
  get_it: ^7.6.0
  logger: ^2.0.1
  connectivity_plus: ^4.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  
  # Code Generation - REQUIRED
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
  retrofit_generator: ^7.0.8
  
  # Testing - MANDATORY
  mocktail: ^1.0.0
  bloc_test: ^9.1.4
```

### Flutter Build Commands - IDE Memory
```bash
# DEVELOPMENT BUILD RULES
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

# PRODUCTION BUILD RULES
flutter build apk --release --shrink
flutter build appbundle --release --shrink
flutter build ios --release

# DEBUG BUILD RULES
flutter run --debug --hot
flutter run --profile --trace-startup

# CODE GENERATION - RUN BEFORE EVERY BUILD
flutter pub run build_runner build --delete-conflicting-outputs

# ANALYSIS - RUN BEFORE COMMIT
flutter analyze
flutter test --coverage
```

## Project Structure Rules - MANDATORY

```
lib/
├── main.dart                 # Entry point
├── app/                      # App-level configuration
│   ├── app.dart             # Main app widget
│   ├── routes.dart          # Navigation routes
│   └── theme.dart           # App theme constants
├── core/                     # Shared core functionality
│   ├── constants/           # Colors, strings, sizes
│   ├── errors/              # Exception classes
│   ├── network/             # API configuration
│   └── utils/               # Helper functions
├── features/                 # Feature-based modules
│   ├── dashboard/           
│   │   ├── data/            # Data sources, models
│   │   ├── domain/          # Business logic, entities
│   │   └── presentation/    # UI, BLoC, pages
│   ├── alerts/
│   ├── collaboration/
│   └── settings/
└── shared/                   # Shared widgets & services
    ├── widgets/             # Reusable UI components
    └── services/            # Shared services
```

## Code Standards - ENFORCE THESE

### 1. Widget Naming Convention
```dart
// ✅ CORRECT - Use descriptive, specific names
class WaveHexagonGrid extends StatelessWidget {}
class DashboardTimelineSlider extends StatefulWidget {}
class DataLayerToggleCard extends StatelessWidget {}

// ❌ WRONG - Avoid generic names
class Grid extends StatelessWidget {}
class Slider extends StatefulWidget {}
class Card extends StatelessWidget {}
```

### 2. BLoC Pattern - MANDATORY Structure
```dart
// events.dart
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  
  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  final String layerId;
  const LoadDashboardData(this.layerId);
  
  @override
  List<Object> get props => [layerId];
}

// states.dart
abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<HexagonRegion> regions;
  final DataLayer activeLayer;
  
  const DashboardLoaded(this.regions, this.activeLayer);
  
  @override
  List<Object> get props => [regions, activeLayer];
}

// bloc.dart
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DataRepository repository;
  
  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }
  
  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final regions = await repository.getRegions(event.layerId);
      final layer = await repository.getLayer(event.layerId);
      emit(DashboardLoaded(regions, layer));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
```

### 3. Model Classes - REQUIRED Format
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'data_layer.g.dart';

@JsonSerializable()
class DataLayer extends Equatable {
  final String id;
  final String name;
  final String description;
  final String color;
  final bool enabled;
  final double opacity;
  final String instrument;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  
  const DataLayer({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.enabled,
    required this.opacity,
    required this.instrument,
    required this.lastUpdated,
  });
  
  factory DataLayer.fromJson(Map<String, dynamic> json) => 
      _$DataLayerFromJson(json);
  
  Map<String, dynamic> toJson() => _$DataLayerToJson(this);
  
  DataLayer copyWith({
    String? id,
    String? name,
    bool? enabled,
    double? opacity,
  }) {
    return DataLayer(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description,
      color: color,
      enabled: enabled ?? this.enabled,
      opacity: opacity ?? this.opacity,
      instrument: instrument,
      lastUpdated: lastUpdated,
    );
  }
  
  @override
  List<Object> get props => [id, name, enabled, opacity, lastUpdated];
}
```

### 4. Constants - WAVE App Specific
```dart
// lib/core/constants/wave_colors.dart
class WaveColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAA);
  
  // Data Layer Colors - EXACT VALUES
  static const Color modis = Color(0xFF4CAF50);
  static const Color aster = Color(0xFFFF9800);
  static const Color misr = Color(0xFF9C27B0);
  static const Color ceres = Color(0xFFF44336);
  static const Color mopitt = Color(0xFF2196F3);
}

// lib/core/constants/wave_dimensions.dart
class WaveDimensions {
  static const double headerHeight = 60.0;
  static const double timelineHeight = 80.0;
  static const double fabSize = 56.0;
  static const double bottomNavHeight = 70.0;
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}
```

## Build Optimization Rules - CRITICAL

### 1. Asset Organization
```yaml
# pubspec.yaml - Assets section
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - assets/data/
  
  fonts:
    - family: WaveFont
      fonts:
        - asset: assets/fonts/WaveFont-Regular.ttf
        - asset: assets/fonts/WaveFont-Bold.ttf
          weight: 700
```

### 2. Performance Rules
```dart
// ✅ CORRECT - Use const constructors
const WaveAppBar(
  title: 'WAVE',
  backgroundColor: WaveColors.surface,
);

// ✅ CORRECT - Lazy loading for heavy widgets
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoaded) {
            return const WaveHexagonGrid(); // Lazy load heavy component
          }
          return const WaveLoadingWidget();
        },
      ),
    );
  }
}

// ✅ CORRECT - Use keys for stateful widgets
ListView.builder(
  itemCount: regions.length,
  itemBuilder: (context, index) {
    return WaveHexagonTile(
      key: ValueKey(regions[index].id), // MANDATORY for performance
      region: regions[index],
    );
  },
);
```

### 3. Error Handling - MANDATORY Pattern
```dart
class WaveRepository {
  Future<Result<List<DataLayer>>> getLayers() async {
    try {
      final response = await _apiService.getLayers();
      return Result.success(response);
    } on DioException catch (e) {
      return Result.failure(NetworkException(e.message));
    } catch (e) {
      return Result.failure(UnknownException(e.toString()));
    }
  }
}

// Result class - USE THIS PATTERN
class Result<T> {
  final T? data;
  final Exception? error;
  final bool isSuccess;
  
  Result.success(this.data) : error = null, isSuccess = true;
  Result.failure(this.error) : data = null, isSuccess = false;
}
```

## Build Commands Memory - EXECUTE IN ORDER

### Before Every Commit
```bash
# 1. Clean and regenerate
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 2. Analyze and test
flutter analyze
flutter test --coverage

# 3. Check formatting
dart format lib/ --set-exit-if-changed
```

### Release Build Checklist
```bash
# 1. Update version in pubspec.yaml
# 2. Clean everything
flutter clean
rm -rf build/

# 3. Get dependencies
flutter pub get

# 4. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Build release
flutter build apk --release --shrink --split-per-abi
flutter build appbundle --release --shrink

# 6. Test release build
flutter install --release
```

## IDE Configuration - SAVE THESE SETTINGS

### VS Code settings.json
```json
{
  "dart.debugExternalLibraries": false,
  "dart.debugSdkLibraries": false,
  "dart.hotReloadOnSave": "always",
  "dart.lineLength": 100,
  "editor.rulers": [100],
  "editor.formatOnSave": true,
  "files.associations": {
    "*.dart": "dart"
  }
}
```

### Analysis Options - dart_code_metrics
```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
``` 