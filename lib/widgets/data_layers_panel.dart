import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class DataLayersPanel extends StatefulWidget {
  const DataLayersPanel({super.key});

  @override
  State<DataLayersPanel> createState() => _DataLayersPanelState();
}

class _DataLayersPanelState extends State<DataLayersPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final panelHeight = screenHeight * 0.6;
    
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return GestureDetector(
          onTap: () => appState.hideLayersPanel(),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping on panel
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * panelHeight),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: panelHeight,
                        decoration: const BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHandle(),
                            _buildHeader(appState),
                            Expanded(
                              child: _buildLayersList(appState),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.textSecondaryColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
  
  Widget _buildHeader(AppState appState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Data Layers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => appState.hideLayersPanel(),
            icon: const Icon(
              Icons.close,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLayersList(AppState appState) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: appState.dataLayers.entries.map((entry) {
        final layerId = entry.key;
        final layer = entry.value;
        
        return _buildLayerItem(appState, layerId, layer);
      }).toList(),
    );
  }
  
  Widget _buildLayerItem(AppState appState, String layerId, DataLayer layer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: layer.enabled 
              ? layer.color.withOpacity(0.5)
              : AppTheme.textSecondaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle
          Row(
            children: [
              // Color indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: layer.color,
                  shape: BoxShape.circle,
                  boxShadow: layer.enabled ? [
                    BoxShadow(
                      color: layer.color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ] : null,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Layer name
              Expanded(
                child: Text(
                  layer.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: layer.enabled 
                        ? AppTheme.textPrimaryColor 
                        : AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              
              // Toggle switch
              Switch(
                value: layer.enabled,
                onChanged: (value) {
                  appState.toggleDataLayer(layerId);
                },
                activeColor: layer.color,
                activeTrackColor: layer.color.withOpacity(0.3),
                inactiveThumbColor: AppTheme.textSecondaryColor,
                inactiveTrackColor: AppTheme.textSecondaryColor.withOpacity(0.2),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            layer.description,
            style: TextStyle(
              fontSize: 14,
              color: layer.enabled 
                  ? AppTheme.textSecondaryColor 
                  : AppTheme.textSecondaryColor.withOpacity(0.6),
            ),
          ),
          
          // Opacity slider (only shown when enabled)
          if (layer.enabled) const SizedBox(height: 12),
          if (layer.enabled)
            Row(
              children: [
                const Text(
                  'Opacity',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: layer.color,
                      inactiveTrackColor: layer.color.withOpacity(0.3),
                      thumbColor: layer.color,
                      overlayColor: layer.color.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      trackHeight: 2,
                    ),
                    child: Slider(
                      value: layer.opacity,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      onChanged: (value) {
                        appState.setDataLayerOpacity(layerId, value);
                      },
                    ),
                  ),
                ),
                Text(
                  '${(layer.opacity * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}