import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<AlertItem> _alerts = [
    AlertItem(
      id: '1',
      title: 'Wildfire Detected',
      description: 'Large wildfire detected in California, USA',
      severity: AlertSeverity.critical,
      location: 'California, USA',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      confidence: 95,
      instrument: 'MODIS',
    ),
    AlertItem(
      id: '2',
      title: 'Temperature Anomaly',
      description: 'Unusual temperature spike in Arctic region',
      severity: AlertSeverity.warning,
      location: 'Arctic Circle',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      confidence: 87,
      instrument: 'ASTER',
    ),
    AlertItem(
      id: '3',
      title: 'Air Quality Alert',
      description: 'High pollution levels detected in Delhi',
      severity: AlertSeverity.warning,
      location: 'Delhi, India',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      confidence: 92,
      instrument: 'MOPITT',
    ),
    AlertItem(
      id: '4',
      title: 'Deforestation Activity',
      description: 'Significant forest loss detected in Amazon',
      severity: AlertSeverity.info,
      location: 'Amazon Rainforest',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      confidence: 78,
      instrument: 'MODIS',
    ),
    AlertItem(
      id: '5',
      title: 'Urban Heat Island',
      description: 'Temperature increase in urban area',
      severity: AlertSeverity.info,
      location: 'Tokyo, Japan',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      confidence: 83,
      instrument: 'ASTER',
    ),
  ];

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
                    child: _buildAlertsList(),
                  ),
                ],
              ),
            ),
          ),
          // Right sidebar with filters and stats
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.warningColor, AppTheme.errorColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Anomaly Detection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Real-time environmental alerts and anomaly detection',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAlertStats(),
                  ],
                ),
              ),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertStats() {
    final criticalCount = _alerts.where((a) => a.severity == AlertSeverity.critical).length;
    final warningCount = _alerts.where((a) => a.severity == AlertSeverity.warning).length;
    final infoCount = _alerts.where((a) => a.severity == AlertSeverity.info).length;

    return Row(
      children: [
        _buildStatCard('Critical', criticalCount, AppTheme.errorColor),
        const SizedBox(width: 16),
        _buildStatCard('Warning', warningCount, AppTheme.warningColor),
        const SizedBox(width: 16),
        _buildStatCard('Info', infoCount, AppTheme.infoColor),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionButton(Icons.filter_list, 'Filter'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.refresh, 'Refresh'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.settings, 'Settings'),
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

  Widget _buildAlertsList() {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          _buildAlertsHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                final alert = _alerts[index];
                return _buildAlertCard(alert);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Recent Alerts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              // Handle view all
            },
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(alert.severity).withOpacity(0.2),
          width: 1,
        ),
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
                  color: _getSeverityColor(alert.severity),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              _buildSeverityBadge(alert.severity),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.location_on, alert.location),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.satellite_alt, alert.instrument),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.psychology, '${alert.confidence}%'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                _formatTimestamp(alert.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _showAlertDetails(alert);
                },
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  _dismissAlert(alert);
                },
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(AlertSeverity severity) {
    Color color = _getSeverityColor(severity);
    String label = severity.name.toUpperCase();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.borderColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
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
          _buildFiltersSection(),
          _buildAnalyticsSection(),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
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
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterChip('Critical', AppTheme.errorColor, true),
          const SizedBox(height: 8),
          _buildFilterChip('Warning', AppTheme.warningColor, true),
          const SizedBox(height: 8),
          _buildFilterChip('Info', AppTheme.infoColor, false),
          const SizedBox(height: 16),
          const Text(
            'Instruments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildFilterChip('MODIS', AppTheme.modisColor, true),
          const SizedBox(height: 8),
          _buildFilterChip('ASTER', AppTheme.asterColor, true),
          const SizedBox(height: 8),
          _buildFilterChip('MOPITT', AppTheme.mopittColor, false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle filter toggle
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppTheme.borderColor,
          ),
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
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : AppTheme.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
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
          _buildAnalyticsCard('Alerts Today', '12', AppTheme.primaryColor),
          const SizedBox(height: 12),
          _buildAnalyticsCard('Avg Response Time', '2.3h', AppTheme.warningColor),
          const SizedBox(height: 12),
          _buildAnalyticsCard('Accuracy Rate', '94.2%', AppTheme.successColor),
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

  Widget _buildSettingsSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alert Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem('Email Notifications', true),
            _buildSettingItem('Push Notifications', true),
            _buildSettingItem('SMS Alerts', false),
            _buildSettingItem('Auto-dismiss Low Priority', true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save settings
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // Handle toggle
            },
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return AppTheme.errorColor;
      case AlertSeverity.warning:
        return AppTheme.warningColor;
      case AlertSeverity.info:
        return AppTheme.infoColor;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showAlertDetails(AlertItem alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.description),
            const SizedBox(height: 16),
            Text('Location: ${alert.location}'),
            Text('Instrument: ${alert.instrument}'),
            Text('Confidence: ${alert.confidence}%'),
            Text('Time: ${_formatTimestamp(alert.timestamp)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _dismissAlert(AlertItem alert) {
    setState(() {
      _alerts.removeWhere((a) => a.id == alert.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert "${alert.title}" dismissed'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}

class AlertItem {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String location;
  final DateTime timestamp;
  final int confidence;
  final String instrument;

  AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.location,
    required this.timestamp,
    required this.confidence,
    required this.instrument,
  });
}

enum AlertSeverity {
  critical,
  warning,
  info,
}

