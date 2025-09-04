import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/earth_globe_3d.dart';
import '../widgets/timeline_slider.dart';
import '../widgets/data_layers_panel.dart';
import '../utils/responsive_helper.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);
    
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Stack(
            children: [
              // Main Content
              Column(
                children: [
                  // Header with real-time data indicators
                  _buildEnhancedHeader(context),
                  
                  // Main Dashboard Content
                  Expanded(
                    child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                  ),
                  
                  // Enhanced Timeline with data controls
                  _buildEnhancedTimeline(),
                ],
              ),
              
              // Floating Controls
              _buildFloatingControls(appState),
              
              // Data Layers Panel
              if (appState.layersPanelVisible)
                const DataLayersPanel(),
                
              // Real-time data overlay
              _buildRealTimeDataOverlay(),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Panel - Data Controls
        Container(
          width: 300,
          color: AppTheme.surfaceColor,
          child: _buildDataControlPanel(),
        ),
        
        // Center - 3D Globe
        Expanded(
          flex: 2,
          child: _buildGlobeArea(),
        ),
        
        // Right Panel - Real-time Data
        Container(
          width: 280,
          color: AppTheme.surfaceColor,
          child: _buildRealTimeDataPanel(),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // 3D Globe Area
        Expanded(
          flex: 3,
          child: _buildGlobeArea(),
        ),
        
        // Data Summary Panel
        Container(
          height: 200,
          color: AppTheme.surfaceColor,
          child: _buildMobileDataSummary(),
        ),
      ],
    );
  }
  
  Widget _buildGlobeArea() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            const Color(0xFF000011),
            const Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 3D Earth Globe
          Center(
            child: EarthGlobe3D(
              width: ResponsiveHelper.isDesktop(context) ? 500 : 350,
              height: ResponsiveHelper.isDesktop(context) ? 500 : 350,
              onResetView: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Globe view reset'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
          
          // Globe Controls Overlay
          Positioned(
            top: 20,
            right: 20,
            child: _buildGlobeControls(),
          ),
          
          // Coordinate Display
          Positioned(
            bottom: 20,
            left: 20,
            child: _buildCoordinateDisplay(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFloatingControls(AppState appState) {
    return Positioned(
      bottom: 120,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reset View Button
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () {
              // Reset globe view - this will be handled by the globe widget
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(
              Icons.refresh,
              color: AppTheme.textPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Layers Button
          FloatingActionButton(
            heroTag: "layers",
            onPressed: () {
              appState.showLayersPanel();
                  },
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.layers,
                    color: AppTheme.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Data Toggle Button
                FloatingActionButton(
                  heroTag: "data",
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  backgroundColor: AppTheme.ceresColor,
                  child: const Icon(
                    Icons.analytics,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }
        
        Widget _buildGlobeControls() {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Globe Controls',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.zoom_in, color: AppTheme.textPrimary, size: 20),
                      tooltip: 'Zoom In',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.zoom_out, color: AppTheme.textPrimary, size: 20),
                      tooltip: 'Zoom Out',
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        
        Widget _buildCoordinateDisplay() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Coordinates',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Lat: 0.0°, Lng: 0.0°',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          );
        }
        
        Widget _buildDataControlPanel() {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Layers',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // MODIS Layer
                _buildLayerControl('MODIS', 'Terra/Aqua Imagery', AppTheme.modisColor, true),
                const SizedBox(height: 12),
                
                // MOPITT Layer
                _buildLayerControl('MOPITT', 'Carbon Monoxide', AppTheme.mopittColor, false),
                const SizedBox(height: 12),
                
                // CERES Layer
                _buildLayerControl('CERES', 'Earth Radiation', AppTheme.ceresColor, false),
                const SizedBox(height: 12),
                
                // ASTER Layer
                _buildLayerControl('ASTER', 'Land Surface', AppTheme.asterColor, false),
                
                const Spacer(),
                
                // Data Source Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Source',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NASA Terra Satellite\nReal-time & Archive',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        Widget _buildLayerControl(String name, String description, Color color, bool isActive) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? color.withOpacity(0.1) : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? color : AppTheme.textSecondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) {},
                  activeColor: color,
                ),
              ],
            ),
          );
        }
        
        Widget _buildRealTimeDataPanel() {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Real-time Data',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Temperature Data
                _buildDataCard('Global Temperature', '14.2°C', '+0.8°C', AppTheme.ceresColor),
                const SizedBox(height: 12),
                
                // CO Levels
                _buildDataCard('CO Levels', '89 ppb', '+2.1%', AppTheme.mopittColor),
                const SizedBox(height: 12),
                
                // Cloud Cover
                _buildDataCard('Cloud Cover', '67%', '-1.2%', AppTheme.modisColor),
                const SizedBox(height: 12),
                
                // Radiation Budget
                _buildDataCard('Radiation Budget', '240 W/m²', '+0.5%', AppTheme.asterColor),
                
                const Spacer(),
                
                // Last Update
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.update,
                        color: AppTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Updated 2 min ago',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        Widget _buildDataCard(String title, String value, String change, Color color) {
          final isPositive = change.startsWith('+');
          
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        change,
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        
        Widget _buildMobileDataSummary() {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Live Data Summary',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMiniDataCard('Temp', '14.2°C', AppTheme.ceresColor)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMiniDataCard('CO', '89 ppb', AppTheme.mopittColor)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMiniDataCard('Clouds', '67%', AppTheme.modisColor)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildMiniDataCard('Radiation', '240 W/m²', AppTheme.asterColor)),
                  ],
                ),
              ],
            ),
          );
        }
        
        Widget _buildMiniDataCard(String title, String value, Color color) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        
        Widget _buildEnhancedTimeline() {
          return Container(
            height: 80,
            color: AppTheme.surfaceColor,
            child: const TimelineSlider(),
          );
        }
        
        Widget _buildRealTimeDataOverlay() {
          return Positioned(
            top: 80,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.satellite_alt,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Terra Satellite: Active',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
  
  Widget _buildEnhancedHeader(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Logo
              const Text(
                'WAVE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              
              const Spacer(),
              
              // Search Icon
              IconButton(
                onPressed: () {
                  // TODO: Implement search functionality
                },
                icon: const Icon(
                  Icons.search,
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Profile Avatar
              GestureDetector(
                onTap: () {
                  // TODO: Implement profile menu
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor,
                    border: Border.all(
                      color: AppTheme.textPrimary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.textPrimary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}