
class AppConstants {
  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 3);
  
  // Border radius values
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
  
  // Spacing values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;
  
  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;
  
  // Elevation values
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // Opacity values
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.87;
  
  // Globe widget constants
  static const double globeSize = 300.0;
  static const double globeRotationSpeed = 0.5;
  static const double globePulseScale = 1.1;
  
  // Timeline constants
  static const int startYear = 2000;
  static const int endYear = 2024;
  static const double timelineHeight = 80.0;
  
  // Data layer constants
  static const double layerOpacityMin = 0.0;
  static const double layerOpacityMax = 1.0;
  static const double layerOpacityDefault = 0.7;
  
  // Story card constants
  static const double storyCardMaxHeight = 400.0;
  static const int storyCardAnimationDuration = 300;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  
  // Asset paths
  static const String earthImagePath = 'assets/images/earth.jpg';
  static const String logoPath = 'assets/images/logo.png';
  
  // API endpoints (placeholder)
  static const String baseApiUrl = 'https://api.nasa.gov';
  static const String satelliteDataEndpoint = '/satellite-data';
  
  // Error messages
  static const String networkErrorMessage = 'Network connection failed. Please check your internet connection.';
  static const String dataLoadErrorMessage = 'Failed to load data. Please try again.';
  static const String genericErrorMessage = 'An unexpected error occurred.';
  
  // Success messages
  static const String dataLoadedMessage = 'Data loaded successfully';
  static const String downloadCompleteMessage = 'Download completed';
  
  // Loading messages
  static const String loadingDataMessage = 'Loading satellite data...';
  static const String processingMessage = 'Processing...';
  
  // Accessibility
  static const String globeSemanticLabel = 'Interactive 3D Earth globe';
  static const String timelineSemanticLabel = 'Timeline slider for selecting year';
  static const String layerToggleSemanticLabel = 'Toggle data layer visibility';
  static const String playButtonSemanticLabel = 'Play timeline animation';
  static const String pauseButtonSemanticLabel = 'Pause timeline animation';
  
  // NASA instrument descriptions
  static const Map<String, String> instrumentDescriptions = {
    'MODIS': 'Moderate Resolution Imaging Spectroradiometer - Observes Earth\'s surface and atmosphere',
    'ASTER': 'Advanced Spaceborne Thermal Emission and Reflection Radiometer - High-resolution imaging',
    'MISR': 'Multi-angle Imaging SpectroRadiometer - Multi-directional Earth observations',
    'CERES': 'Clouds and Earth\'s Radiant Energy System - Energy balance measurements',
    'MOPITT': 'Measurements of Pollution in the Troposphere - Atmospheric pollution monitoring',
  };
  
  // Region data
  static const Map<String, Map<String, dynamic>> regionData = {
    'amazon': {
      'name': 'Amazon Basin',
      'description': 'The world\'s largest tropical rainforest, spanning across 9 countries in South America.',
      'coordinates': {'lat': -3.4653, 'lng': -62.2159},
      'area': '5.5 million km²',
      'countries': ['Brazil', 'Peru', 'Colombia', 'Venezuela', 'Ecuador', 'Bolivia', 'Guyana', 'Suriname', 'French Guiana'],
    },
    'arctic': {
      'name': 'Arctic Region',
      'description': 'The northernmost region of Earth, characterized by sea ice, permafrost, and unique ecosystems.',
      'coordinates': {'lat': 90.0, 'lng': 0.0},
      'area': '14.05 million km²',
      'countries': ['Canada', 'Russia', 'United States', 'Norway', 'Denmark', 'Iceland', 'Sweden', 'Finland'],
    },
    'sahara': {
      'name': 'Sahara Desert',
      'description': 'The world\'s largest hot desert, covering much of North Africa.',
      'coordinates': {'lat': 23.8859, 'lng': 18.9716},
      'area': '9.2 million km²',
      'countries': ['Algeria', 'Chad', 'Egypt', 'Libya', 'Mali', 'Mauritania', 'Morocco', 'Niger', 'Sudan', 'Tunisia'],
    },
  };
}