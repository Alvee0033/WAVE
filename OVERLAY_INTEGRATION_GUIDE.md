# NASA Terra Instrument Data Overlay Integration Guide

## Overview
This guide explains how to integrate NASA Terra satellite instrument data (MODIS, MOPITT, CERES, ASTER, MISR) as overlay layers on the 3D Earth globe.

## Architecture Overview

The 3D globe system is designed with a modular overlay architecture:

```
EarthGlobe3D Widget
├── Base Earth Rendering (EarthGlobePainter)
├── Overlay Layer System
│   ├── MODIS Data Overlay
│   ├── MOPITT Data Overlay
│   ├── CERES Data Overlay
│   ├── ASTER Data Overlay
│   └── MISR Data Overlay
└── Interactive Controls
```

## 1. Data Layer Integration Points

### A. EarthGlobe3D Widget (`lib/widgets/earth_globe_3d.dart`)

**Location to Add Overlay Data:**
- Line 350+ (after `_drawAtmosphereGlow` method)
- Add new method: `_drawDataOverlays(Canvas canvas, Offset center, double radius)`

```dart
void _drawDataOverlays(Canvas canvas, Offset center, double radius) {
  // Draw MODIS data overlay
  if (_modisDataVisible) {
    _drawModisOverlay(canvas, center, radius);
  }
  
  // Draw MOPITT data overlay
  if (_mopittDataVisible) {
    _drawMopittOverlay(canvas, center, radius);
  }
  
  // Draw CERES data overlay
  if (_ceresDataVisible) {
    _drawCeresOverlay(canvas, center, radius);
  }
  
  // Draw ASTER data overlay
  if (_asterDataVisible) {
    _drawAsterOverlay(canvas, center, radius);
  }
  
  // Draw MISR data overlay
  if (_misrDataVisible) {
    _drawMisrOverlay(canvas, center, radius);
  }
}
```

### B. Data Model Classes

**Create these files:**

1. `lib/models/terra_data_models.dart`
```dart
// MODIS Data Model
class ModisData {
  final double latitude;
  final double longitude;
  final double temperature;
  final double cloudCover;
  final DateTime timestamp;
  
  ModisData({
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.cloudCover,
    required this.timestamp,
  });
}

// MOPITT Data Model
class MopittData {
  final double latitude;
  final double longitude;
  final double carbonMonoxideLevel;
  final double altitude;
  final DateTime timestamp;
  
  MopittData({
    required this.latitude,
    required this.longitude,
    required this.carbonMonoxideLevel,
    required this.altitude,
    required this.timestamp,
  });
}

// CERES Data Model
class CeresData {
  final double latitude;
  final double longitude;
  final double incomingRadiation;
  final double outgoingRadiation;
  final double netRadiation;
  final DateTime timestamp;
  
  CeresData({
    required this.latitude,
    required this.longitude,
    required this.incomingRadiation,
    required this.outgoingRadiation,
    required this.netRadiation,
    required this.timestamp,
  });
}

// ASTER Data Model
class AsterData {
  final double latitude;
  final double longitude;
  final double surfaceTemperature;
  final double elevation;
  final String landCoverType;
  final DateTime timestamp;
  
  AsterData({
    required this.latitude,
    required this.longitude,
    required this.surfaceTemperature,
    required this.elevation,
    required this.landCoverType,
    required this.timestamp,
  });
}

// MISR Data Model
class MisrData {
  final double latitude;
  final double longitude;
  final double aerosolOpticalDepth;
  final double particleSize;
  final DateTime timestamp;
  
  MisrData({
    required this.latitude,
    required this.longitude,
    required this.aerosolOpticalDepth,
    required this.particleSize,
    required this.timestamp,
  });
}
```

## 2. API Integration

### A. NASA API Service (`lib/services/nasa_api_service.dart`)

```dart
import 'package:dio/dio.dart';
import '../models/terra_data_models.dart';

class NasaApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.nasa.gov';
  final String _apiKey; // You'll need to provide this
  
  NasaApiService(this._apiKey);
  
  // Fetch MODIS data
  Future<List<ModisData>> fetchModisData({
    required double minLat,
    required double maxLat,
    required double minLon,
    required double maxLon,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/planetary/earth/imagery',
        queryParameters: {
          'lon': (minLon + maxLon) / 2,
          'lat': (minLat + maxLat) / 2,
          'date': startDate.toIso8601String().split('T')[0],
          'api_key': _apiKey,
        },
      );
      
      // Parse response and return ModisData list
      return _parseModisData(response.data);
    } catch (e) {
      throw Exception('Failed to fetch MODIS data: $e');
    }
  }
  
  // Similar methods for other instruments...
  Future<List<MopittData>> fetchMopittData({...}) async { ... }
  Future<List<CeresData>> fetchCeresData({...}) async { ... }
  Future<List<AsterData>> fetchAsterData({...}) async { ... }
  Future<List<MisrData>> fetchMisrData({...}) async { ... }
}
```

## 3. Overlay Rendering Implementation

### A. Add to EarthGlobePainter class:

```dart
// Add these methods to EarthGlobePainter class

void _drawModisOverlay(Canvas canvas, Offset center, double radius) {
  if (modisData == null || modisData!.isEmpty) return;
  
  final paint = Paint()
    ..color = AppTheme.modisColor.withOpacity(0.7)
    ..style = PaintingStyle.fill;
  
  for (final data in modisData!) {
    final point = _latLngToScreenPoint(
      data.latitude, 
      data.longitude, 
      center, 
      radius
    );
    
    if (point != null) {
      // Draw temperature data as colored circles
      final intensity = (data.temperature + 50) / 100; // Normalize
      paint.color = Color.lerp(
        Colors.blue,
        Colors.red,
        intensity,
      )!.withOpacity(0.6);
      
      canvas.drawCircle(point, 3, paint);
    }
  }
}

void _drawMopittOverlay(Canvas canvas, Offset center, double radius) {
  if (mopittData == null || mopittData!.isEmpty) return;
  
  final paint = Paint()
    ..style = PaintingStyle.fill;
  
  for (final data in mopittData!) {
    final point = _latLngToScreenPoint(
      data.latitude, 
      data.longitude, 
      center, 
      radius
    );
    
    if (point != null) {
      // Draw CO levels as colored squares
      final intensity = data.carbonMonoxideLevel / 200; // Normalize
      paint.color = Color.lerp(
        Colors.green,
        Colors.orange,
        intensity,
      )!.withOpacity(0.8);
      
      canvas.drawRect(
        Rect.fromCenter(center: point, width: 4, height: 4),
        paint,
      );
    }
  }
}

void _drawCeresOverlay(Canvas canvas, Offset center, double radius) {
  if (ceresData == null || ceresData!.isEmpty) return;
  
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  
  for (final data in ceresData!) {
    final point = _latLngToScreenPoint(
      data.latitude, 
      data.longitude, 
      center, 
      radius
    );
    
    if (point != null) {
      // Draw radiation data as colored rings
      final intensity = data.netRadiation / 400; // Normalize
      paint.color = Color.lerp(
        Colors.purple,
        Colors.yellow,
        intensity,
      )!.withOpacity(0.7);
      
      canvas.drawCircle(point, 5, paint);
    }
  }
}

// Helper method to convert lat/lng to screen coordinates
Offset? _latLngToScreenPoint(
  double lat, 
  double lng, 
  Offset center, 
  double radius
) {
  // Convert latitude/longitude to 3D sphere coordinates
  final latRad = lat * math.pi / 180;
  final lngRad = (lng + rotationY * 180 / math.pi) * math.pi / 180;
  
  final x = radius * math.cos(latRad) * math.sin(lngRad);
  final y = radius * math.sin(latRad);
  final z = radius * math.cos(latRad) * math.cos(lngRad);
  
  // Only render points on the visible side of the globe
  if (z < 0) return null;
  
  return Offset(
    center.dx + x,
    center.dy - y, // Flip Y coordinate
  );
}
```

## 4. Data Management

### A. Create Data Manager (`lib/services/terra_data_manager.dart`)

```dart
import 'dart:async';
import '../models/terra_data_models.dart';
import 'nasa_api_service.dart';

class TerraDataManager {
  final NasaApiService _apiService;
  
  // Data streams
  final _modisController = StreamController<List<ModisData>>.broadcast();
  final _mopittController = StreamController<List<MopittData>>.broadcast();
  final _ceresController = StreamController<List<CeresData>>.broadcast();
  final _asterController = StreamController<List<AsterData>>.broadcast();
  final _misrController = StreamController<List<MisrData>>.broadcast();
  
  // Getters for streams
  Stream<List<ModisData>> get modisStream => _modisController.stream;
  Stream<List<MopittData>> get mopittStream => _mopittController.stream;
  Stream<List<CeresData>> get ceresStream => _ceresController.stream;
  Stream<List<AsterData>> get asterStream => _asterController.stream;
  Stream<List<MisrData>> get misrStream => _misrController.stream;
  
  TerraDataManager(this._apiService);
  
  // Fetch data for visible globe area
  Future<void> fetchDataForRegion({
    required double minLat,
    required double maxLat,
    required double minLon,
    required double maxLon,
    required DateTime date,
  }) async {
    try {
      // Fetch all instrument data in parallel
      final futures = [
        _apiService.fetchModisData(
          minLat: minLat, maxLat: maxLat,
          minLon: minLon, maxLon: maxLon,
          startDate: date, endDate: date,
        ),
        _apiService.fetchMopittData(
          minLat: minLat, maxLat: maxLat,
          minLon: minLon, maxLon: maxLon,
          startDate: date, endDate: date,
        ),
        // Add other instrument data fetches...
      ];
      
      final results = await Future.wait(futures);
      
      // Emit data to streams
      _modisController.add(results[0] as List<ModisData>);
      _mopittController.add(results[1] as List<MopittData>);
      // Add other data emissions...
      
    } catch (e) {
      print('Error fetching Terra data: $e');
    }
  }
  
  void dispose() {
    _modisController.close();
    _mopittController.close();
    _ceresController.close();
    _asterController.close();
    _misrController.close();
  }
}
```

## 5. Integration with Main Dashboard

### A. Update MainDashboard (`lib/screens/main_dashboard.dart`)

Add these imports and modify the `_buildGlobeArea` method:

```dart
import '../services/terra_data_manager.dart';
import '../models/terra_data_models.dart';

// Add to _MainDashboardState class:
late TerraDataManager _dataManager;
List<ModisData> _modisData = [];
List<MopittData> _mopittData = [];
List<CeresData> _ceresData = [];

@override
void initState() {
  super.initState();
  _dataManager = TerraDataManager(NasaApiService('YOUR_NASA_API_KEY'));
  _setupDataStreams();
}

void _setupDataStreams() {
  _dataManager.modisStream.listen((data) {
    setState(() {
      _modisData = data;
    });
  });
  
  _dataManager.mopittStream.listen((data) {
    setState(() {
      _mopittData = data;
    });
  });
  
  // Add other stream listeners...
}

// Update the EarthGlobe3D widget creation:
EarthGlobe3D(
  width: ResponsiveHelper.isDesktop(context) ? 500 : 350,
  height: ResponsiveHelper.isDesktop(context) ? 500 : 350,
  modisData: _modisData,
  mopittData: _mopittData,
  ceresData: _ceresData,
  onResetView: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Globe view reset'),
        duration: Duration(seconds: 1),
      ),
    );
  },
),
```

## 6. API Key Configuration

### A. Get NASA API Key
1. Visit: https://api.nasa.gov/
2. Generate your API key
3. Add to your app configuration

### B. Environment Configuration
Create `lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String nasaApiKey = 'YOUR_NASA_API_KEY_HERE';
  static const String nasaBaseUrl = 'https://api.nasa.gov';
  
  // NASA Terra instrument endpoints
  static const String modisEndpoint = '/planetary/earth/imagery';
  static const String mopittEndpoint = '/planetary/earth/assets';
  static const String ceresEndpoint = '/planetary/earth/statistics';
}
```

## 7. Real-time Data Updates

### A. Add Timer for Data Refresh

```dart
// In _MainDashboardState:
Timer? _dataRefreshTimer;

@override
void initState() {
  super.initState();
  _setupDataRefresh();
}

void _setupDataRefresh() {
  _dataRefreshTimer = Timer.periodic(
    const Duration(minutes: 5), // Refresh every 5 minutes
    (timer) {
      _refreshTerraData();
    },
  );
}

Future<void> _refreshTerraData() async {
  await _dataManager.fetchDataForRegion(
    minLat: -90, maxLat: 90,
    minLon: -180, maxLon: 180,
    date: DateTime.now(),
  );
}

@override
void dispose() {
  _dataRefreshTimer?.cancel();
  _dataManager.dispose();
  super.dispose();
}
```

## 8. Performance Optimization

### A. Data Filtering
- Only load data for visible globe region
- Implement level-of-detail (LOD) based on zoom level
- Cache frequently accessed data

### B. Rendering Optimization
- Use efficient painting techniques
- Implement data point clustering for dense areas
- Add frame rate monitoring

## 9. Testing

### A. Mock Data for Development
Create `lib/services/mock_terra_data.dart` for testing without API calls:

```dart
class MockTerraData {
  static List<ModisData> generateMockModisData() {
    return List.generate(100, (index) {
      return ModisData(
        latitude: (index % 180) - 90.0,
        longitude: (index % 360) - 180.0,
        temperature: 15.0 + (index % 30),
        cloudCover: (index % 100) / 100.0,
        timestamp: DateTime.now(),
      );
    });
  }
  
  // Similar methods for other instruments...
}
```

## Summary

This integration guide provides a complete framework for adding NASA Terra instrument data overlays to your 3D Earth globe. The modular design allows you to:

1. **Add new instruments easily** by following the same pattern
2. **Customize visualization** for each data type
3. **Handle real-time updates** efficiently
4. **Scale to handle large datasets** with optimization techniques

The key integration points are:
- **Data Models**: Define structure for each instrument
- **API Service**: Fetch data from NASA APIs
- **Overlay Rendering**: Visualize data on the globe
- **Data Management**: Handle streams and updates
- **UI Integration**: Connect with dashboard controls

Start with one instrument (e.g., MODIS) and gradually add others following the same pattern.