import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/cesium_earth_widget.dart';
import '../widgets/timeline_slider.dart';
import '../widgets/data_layers_panel.dart';
import '../utils/responsive_helper.dart';
import '../theme/app_theme.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  // Filters state for Explore page reskin
  final List<String> _filters = const [
    'Temperature', 'Vegetation', 'Air Quality', 'Clouds', 'Radiation', 'Ozone'
  ];
  final Set<String> _selectedFilters = <String>{};

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _filters.map((f) {
        final bool selected = _selectedFilters.contains(f);
        return GestureDetector(
          onTap: () => _toggleFilter(f),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppTheme.primaryColor.withOpacity(0.4) : AppTheme.borderColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.circle,
                  size: 14,
                  color: selected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  f,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 30000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _scaleController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Main content area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
          // Right sidebar with controls
          _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.modernCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.public,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Earth Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Search regions, layers, or instruments in real-time',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconAction(Icons.refresh, 'Reset View'),
                      const SizedBox(width: 8),
                      _buildIconAction(Icons.fullscreen, 'Fullscreen'),
                      const SizedBox(width: 8),
                      _buildIconAction(Icons.share, 'Share'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Search field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppTheme.textSecondaryColor, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search regions, layers, instruments...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Status chip
                  _buildStatusChip('Live Data', AppTheme.successColor),
                  const SizedBox(width: 8),
                  _buildStatusChip('5 Instruments', AppTheme.infoColor),
                  const SizedBox(width: 8),
                  _buildStatusChip('Global', AppTheme.accentColor),
                ],
              ),
              const SizedBox(height: 12),
              _buildFilterChips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      children: [
        _buildStatusIndicator('Live Data', AppTheme.successColor, true),
        const SizedBox(width: 16),
        _buildStatusIndicator('5 Instruments', AppTheme.infoColor, true),
        const SizedBox(width: 16),
        _buildStatusIndicator('Global Coverage', AppTheme.accentColor, true),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, Color color, bool isActive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? color : AppTheme.textSecondaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? color : AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionButton(Icons.refresh, 'Reset View'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.fullscreen, 'Fullscreen'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.share, 'Share'),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: IconButton(
          onPressed: () {
            // Handle action
          },
          icon: Icon(
            icon,
            color: AppTheme.textSecondaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildIconAction(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Icon(
          icon,
          color: AppTheme.textSecondaryColor,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      children: [
        // 3D Earth Globe
        Expanded(
          flex: 3,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: AppTheme.modernCardDecoration(),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return CesiumEarthWidget(
                      width: ResponsiveHelper.isDesktop(context) ? 500 : 350,
                      height: ResponsiveHelper.isDesktop(context) ? 500 : 350,
                      dataLayers: _getDataLayersForCesium(context.read<AppState>()),
                      onResetView: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Globe view reset'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppTheme.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      onLocationChanged: (lat, lng) {
                        // Handle location change
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Data layers panel
        Expanded(
          flex: 1,
          child: const DataLayersPanel(),
        ),
      ],
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: const Border(
          left: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildTimelineSection(),
          _buildAnalyticsSection(),
          _buildInstrumentsSection(),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          const TimelineSlider(),
          const SizedBox(height: 16),
          _buildTimelineControls(),
        ],
      ),
    );
  }

  Widget _buildTimelineControls() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle play/pause
            },
            icon: const Icon(Icons.play_arrow, size: 16),
            label: const Text('Play'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle reset
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard('Temperature', '22.5°C', AppTheme.asterColor),
          const SizedBox(height: 12),
          _buildAnalyticsCard('Vegetation', '85%', AppTheme.modisColor),
          const SizedBox(height: 12),
          _buildAnalyticsCard('Air Quality', 'Good', AppTheme.mopittColor),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
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
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentsSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Instruments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildInstrumentCard('MODIS', 'Vegetation & Land Cover', AppTheme.modisColor),
                  _buildInstrumentCard('ASTER', 'Surface Temperature', AppTheme.asterColor),
                  _buildInstrumentCard('MISR', 'Atmospheric Particles', AppTheme.misrColor),
                  _buildInstrumentCard('CERES', 'Energy Balance', AppTheme.ceresColor),
                  _buildInstrumentCard('MOPITT', 'Air Quality', AppTheme.mopittColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstrumentCard(String name, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: true,
            onChanged: (value) {
              // Handle toggle
            },
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDataLayersForCesium(AppState appState) {
    return {
      'modis': {
        'enabled': true,
        'opacity': 0.8,
        'color': AppTheme.modisColor,
      },
      'aster': {
        'enabled': true,
        'opacity': 0.6,
        'color': AppTheme.asterColor,
      },
      'misr': {
        'enabled': false,
        'opacity': 0.7,
        'color': AppTheme.misrColor,
      },
      'ceres': {
        'enabled': false,
        'opacity': 0.5,
        'color': AppTheme.ceresColor,
      },
      'mopitt': {
        'enabled': true,
        'opacity': 0.9,
        'color': AppTheme.mopittColor,
      },
    };
  }
}
