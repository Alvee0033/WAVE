import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Current year for timeline
  int _currentYear = 2024;
  int get currentYear => _currentYear;
  
  // Timeline playing state
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  
  // Data layers state
  final Map<String, DataLayer> _dataLayers = {
    'modis': DataLayer(
      name: 'MODIS - Vegetation',
      color: const Color(0xFF4CAF50),
      enabled: true,
      opacity: 0.8,
      description: 'Land cover and vegetation health',
    ),
    'aster': DataLayer(
      name: 'ASTER - Thermal',
      color: const Color(0xFFFF9800),
      enabled: false,
      opacity: 0.7,
      description: 'Surface temperature mapping',
    ),
    'misr': DataLayer(
      name: 'MISR - Aerosols',
      color: const Color(0xFF9C27B0),
      enabled: false,
      opacity: 0.6,
      description: 'Atmospheric particles and clouds',
    ),
    'ceres': DataLayer(
      name: 'CERES - Radiation',
      color: const Color(0xFFF44336),
      enabled: false,
      opacity: 0.5,
      description: 'Earth\'s energy balance',
    ),
    'mopitt': DataLayer(
      name: 'MOPITT - Air Quality',
      color: const Color(0xFF2196F3),
      enabled: false,
      opacity: 0.9,
      description: 'Carbon monoxide levels',
    ),
  };
  
  Map<String, DataLayer> get dataLayers => _dataLayers;
  
  // Globe interaction state
  bool _globeInteractionEnabled = true;
  bool get globeInteractionEnabled => _globeInteractionEnabled;
  
  // Selected region
  String? _selectedRegion;
  String? get selectedRegion => _selectedRegion;
  
  // Data layers panel visibility
  bool _layersPanelVisible = false;
  bool get layersPanelVisible => _layersPanelVisible;
  
  void setCurrentYear(int year) {
    _currentYear = year;
    notifyListeners();
  }
  
  void toggleTimelinePlayback() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }
  
  void setTimelinePlayback(bool playing) {
    _isPlaying = playing;
    notifyListeners();
  }
  
  void toggleDataLayer(String layerId) {
    if (_dataLayers.containsKey(layerId)) {
      _dataLayers[layerId]!.enabled = !_dataLayers[layerId]!.enabled;
      notifyListeners();
    }
  }
  
  void setDataLayerOpacity(String layerId, double opacity) {
    if (_dataLayers.containsKey(layerId)) {
      _dataLayers[layerId]!.opacity = opacity;
      notifyListeners();
    }
  }
  
  void setGlobeInteraction(bool enabled) {
    _globeInteractionEnabled = enabled;
    notifyListeners();
  }
  
  void selectRegion(String? regionId) {
    _selectedRegion = regionId;
    notifyListeners();
  }
  
  void toggleLayersPanel() {
    _layersPanelVisible = !_layersPanelVisible;
    notifyListeners();
  }
  
  void showLayersPanel() {
    _layersPanelVisible = true;
    notifyListeners();
  }
  
  void hideLayersPanel() {
    _layersPanelVisible = false;
    notifyListeners();
  }
}

class DataLayer {
  final String name;
  final Color color;
  bool enabled;
  double opacity;
  final String description;
  
  DataLayer({
    required this.name,
    required this.color,
    required this.enabled,
    required this.opacity,
    required this.description,
  });
}