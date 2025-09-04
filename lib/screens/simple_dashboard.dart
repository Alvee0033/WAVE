import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SimpleDashboard extends StatefulWidget {
  const SimpleDashboard({Key? key}) : super(key: key);

  @override
  State<SimpleDashboard> createState() => _SimpleDashboardState();
}

class _SimpleDashboardState extends State<SimpleDashboard> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  bool _isOnline = true;
  double _timelineValue = 2024;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  // Mock data
  final List<RegionData> _regions = [
    RegionData(
      id: 'amazon-1',
      name: 'Amazon Basin',
      temperature: 28.5,
      vegetation: 0.85,
      airQuality: 42,
      precipitation: 120,
      status: RegionStatus.warning,
      trend: TrendDirection.declining,
    ),
    RegionData(
      id: 'arctic-1',
      name: 'Arctic Circle',
      temperature: -15.2,
      vegetation: 0.12,
      airQuality: 18,
      precipitation: 45,
      status: RegionStatus.critical,
      trend: TrendDirection.rising,
    ),
    RegionData(
      id: 'sahara-1',
      name: 'Sahara Desert',
      temperature: 42.1,
      vegetation: 0.05,
      airQuality: 95,
      precipitation: 2,
      status: RegionStatus.normal,
      trend: TrendDirection.stable,
    ),
    RegionData(
      id: 'pacific-1',
      name: 'Pacific Ocean',
      temperature: 22.8,
      vegetation: 0.0,
      airQuality: 25,
      precipitation: 180,
      status: RegionStatus.normal,
      trend: TrendDirection.stable,
    ),
    RegionData(
      id: 'himalayas-1',
      name: 'Himalayas',
      temperature: -8.5,
      vegetation: 0.45,
      airQuality: 35,
      precipitation: 85,
      status: RegionStatus.warning,
      trend: TrendDirection.rising,
    ),
    RegionData(
      id: 'congo-1',
      name: 'Congo Basin',
      temperature: 26.2,
      vegetation: 0.78,
      airQuality: 48,
      precipitation: 145,
      status: RegionStatus.normal,
      trend: TrendDirection.stable,
    ),
    RegionData(
      id: 'australia-1',
      name: 'Australian Outback',
      temperature: 35.7,
      vegetation: 0.15,
      airQuality: 72,
      precipitation: 15,
      status: RegionStatus.warning,
      trend: TrendDirection.declining,
    ),
    RegionData(
      id: 'siberia-1',
      name: 'Siberian Tundra',
      temperature: -25.1,
      vegetation: 0.25,
      airQuality: 22,
      precipitation: 35,
      status: RegionStatus.critical,
      trend: TrendDirection.rising,
    ),
    RegionData(
      id: 'greenland-1',
      name: 'Greenland Ice',
      temperature: -18.9,
      vegetation: 0.02,
      airQuality: 15,
      precipitation: 28,
      status: RegionStatus.critical,
      trend: TrendDirection.rising,
    ),
    RegionData(
      id: 'mediterranean-1',
      name: 'Mediterranean',
      temperature: 24.3,
      vegetation: 0.55,
      airQuality: 68,
      precipitation: 65,
      status: RegionStatus.normal,
      trend: TrendDirection.stable,
    ),
    RegionData(
      id: 'andes-1',
      name: 'Andes Mountains',
      temperature: 12.8,
      vegetation: 0.38,
      airQuality: 42,
      precipitation: 95,
      status: RegionStatus.normal,
      trend: TrendDirection.stable,
    ),
    RegionData(
      id: 'gobi-1',
      name: 'Gobi Desert',
      temperature: 18.5,
      vegetation: 0.08,
      airQuality: 125,
      precipitation: 8,
      status: RegionStatus.warning,
      trend: TrendDirection.declining,
    ),
  ];

  final List<DataLayer> _dataLayers = [
    DataLayer(
      id: 'temperature',
      name: 'Temperature',
      color: const Color(0xFFFF9800),
      enabled: true,
      opacity: 0.8,
      unit: '°C',
      minRange: -40,
      maxRange: 50,
    ),
    DataLayer(
      id: 'vegetation',
      name: 'Vegetation Index',
      color: const Color(0xFF4CAF50),
      enabled: false,
      opacity: 0.7,
      unit: 'NDVI',
      minRange: 0,
      maxRange: 1,
    ),
    DataLayer(
      id: 'airQuality',
      name: 'Air Quality',
      color: const Color(0xFF2196F3),
      enabled: false,
      opacity: 0.9,
      unit: 'AQI',
      minRange: 0,
      maxRange: 300,
    ),
    DataLayer(
      id: 'precipitation',
      name: 'Precipitation',
      color: const Color(0xFF03DAC6),
      enabled: false,
      opacity: 0.8,
      unit: 'mm',
      minRange: 0,
      maxRange: 200,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),
          ),
          _buildTimelineControl(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'WAVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isOnline ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _isOnline ? 'Online' : 'Offline',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                DateFormat('MMM dd, yyyy HH:mm').format(_currentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildDataLayersPanel(),
        Expanded(child: _buildMainGrid()),
        _buildStatisticsPanel(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildQuickToggleBar(),
        Expanded(child: _buildMainGrid()),
      ],
    );
  }

  Widget _buildDataLayersPanel() {
    return Container(
      width: 250,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Layers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ..._dataLayers.map((layer) => _buildLayerControl(layer)),
        ],
      ),
    );
  }

  Widget _buildLayerControl(DataLayer layer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: layer.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  layer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Switch(
                value: layer.enabled,
                onChanged: (value) {
                  setState(() {
                    layer.enabled = value;
                  });
                },
                activeColor: layer.color,
              ),
            ],
          ),
          if (layer.enabled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Opacity:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: layer.opacity,
                    onChanged: (value) {
                      setState(() {
                        layer.opacity = value;
                      });
                    },
                    activeColor: layer.color,
                    inactiveColor: Colors.white24,
                  ),
                ),
                Text(
                  '${(layer.opacity * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Text(
              'Updated: ${DateFormat('HH:mm').format(_currentTime)}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickToggleBar() {
    return Container(
      height: 50,
      color: const Color(0xFF2A2A2A),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _dataLayers.map((layer) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  layer.enabled = !layer.enabled;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: layer.enabled ? layer.color.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: layer.color,
                    width: layer.enabled ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    layer.name.split(' ')[0],
                    style: TextStyle(
                      color: layer.enabled ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight: layer.enabled ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 600;
          final crossAxisCount = isDesktop ? 4 : 2;
          final childAspectRatio = 1.0;
          
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: _regions.length,
            itemBuilder: (context, index) {
              return _buildRegionCell(_regions[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildRegionCell(RegionData region) {
    final enabledLayer = _dataLayers.firstWhere(
      (layer) => layer.enabled,
      orElse: () => _dataLayers[0],
    );
    
    double value;
    switch (enabledLayer.id) {
      case 'temperature':
        value = region.temperature;
        break;
      case 'vegetation':
        value = region.vegetation;
        break;
      case 'airQuality':
        value = region.airQuality;
        break;
      case 'precipitation':
        value = region.precipitation;
        break;
      default:
        value = region.temperature;
    }

    return GestureDetector(
      onTap: () => _showRegionDetails(region),
      child: MouseRegion(
        onEnter: (_) => setState(() {}),
        onExit: (_) => setState(() {}),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getStatusColor(region.status).withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                region.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${value.toStringAsFixed(1)}${enabledLayer.unit}',
                style: TextStyle(
                  color: enabledLayer.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Status: ${region.status.name}',
                style: TextStyle(
                  color: _getStatusColor(region.status),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  _buildTrendIndicator(region.trend),
                  const Spacer(),
                  Icon(
                    _getTrendIcon(region.trend),
                    color: _getTrendColor(region.trend),
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(TrendDirection trend) {
    return Row(
      children: List.generate(5, (index) {
        bool filled;
        switch (trend) {
          case TrendDirection.rising:
            filled = index < 4;
            break;
          case TrendDirection.declining:
            filled = index < 2;
            break;
          case TrendDirection.stable:
            filled = index < 3;
            break;
        }
        return Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: filled ? _getTrendColor(trend) : Colors.white24,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildStatisticsPanel() {
    return Container(
      width: 300,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatCard(
            'Global Temperature',
            '+1.2°C vs last year',
            'Rising',
            Icons.trending_up,
            Colors.red,
          ),
          _buildStatCard(
            'Forest Coverage',
            '-2.3% vs last year',
            'Declining',
            Icons.trending_down,
            Colors.orange,
          ),
          _buildStatCard(
            'Air Quality Index',
            '87 (Moderate)',
            'Stable',
            Icons.trending_flat,
            Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'Active Alerts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildAlertItem('🚨', '3 Critical', Colors.red),
          _buildAlertItem('⚠️', '12 Warnings', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String status, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Status: $status',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String emoji, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineControl() {
    return Container(
      height: 60,
      color: const Color(0xFF1E1E1E).withOpacity(0.9),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '2020',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Expanded(
            child: Slider(
              value: _timelineValue,
              min: 2020,
              max: 2024,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _timelineValue = value;
                });
              },
              activeColor: const Color(0xFF03DAC6),
              inactiveColor: Colors.white24,
            ),
          ),
          const Text(
            '2024',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              _buildSpeedButton('1x', 1.0),
              _buildSpeedButton('2x', 2.0),
              _buildSpeedButton('5x', 5.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedButton(String label, double speed) {
    final isSelected = _playbackSpeed == speed;
    return GestureDetector(
      onTap: () {
        setState(() {
          _playbackSpeed = speed;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF03DAC6) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF03DAC6),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF03DAC6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showRegionDetails(RegionData region) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          region.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Temperature', '${region.temperature}°C'),
            _buildDetailRow('Vegetation', region.vegetation.toStringAsFixed(2)),
            _buildDetailRow('Air Quality', '${region.airQuality} AQI'),
            _buildDetailRow('Precipitation', '${region.precipitation}mm'),
            const SizedBox(height: 12),
            Text(
              'Status: ${region.status.name}',
              style: TextStyle(
                color: _getStatusColor(region.status),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Trend: ${region.trend.name}',
              style: TextStyle(
                color: _getTrendColor(region.trend),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateFormat('MMM dd, HH:mm').format(_currentTime)}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF03DAC6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RegionStatus status) {
    switch (status) {
      case RegionStatus.normal:
        return const Color(0xFF4CAF50);
      case RegionStatus.warning:
        return const Color(0xFFFF9800);
      case RegionStatus.critical:
        return const Color(0xFFF44336);
      case RegionStatus.unknown:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getTrendColor(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.rising:
        return const Color(0xFFF44336);
      case TrendDirection.declining:
        return const Color(0xFFFF9800);
      case TrendDirection.stable:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getTrendIcon(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.rising:
        return Icons.trending_up;
      case TrendDirection.declining:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}

// Data Models
class RegionData {
  final String id;
  final String name;
  final double temperature;
  final double vegetation;
  final double airQuality;
  final double precipitation;
  final RegionStatus status;
  final TrendDirection trend;

  RegionData({
    required this.id,
    required this.name,
    required this.temperature,
    required this.vegetation,
    required this.airQuality,
    required this.precipitation,
    required this.status,
    required this.trend,
  });
}

class DataLayer {
  final String id;
  final String name;
  final Color color;
  bool enabled;
  double opacity;
  final String unit;
  final double minRange;
  final double maxRange;

  DataLayer({
    required this.id,
    required this.name,
    required this.color,
    required this.enabled,
    required this.opacity,
    required this.unit,
    required this.minRange,
    required this.maxRange,
  });
}

enum RegionStatus { normal, warning, critical, unknown }
enum TrendDirection { rising, declining, stable }