import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Settings state
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsAlerts = false;
  bool _autoDismissLowPriority = true;
  bool _darkMode = false;
  bool _animationsEnabled = true;
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';
  String _selectedQuality = 'High';
  String _selectedUpdateFrequency = '1 hour';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'];
  final List<String> _themes = ['Light', 'Dark', 'Auto'];
  final List<String> _qualities = ['Low', 'Medium', 'High', 'Ultra'];
  final List<String> _updateFrequencies = ['15 minutes', '30 minutes', '1 hour', '3 hours', '6 hours', '12 hours'];

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
                    child: _buildSettingsContent(),
                  ),
                ],
              ),
            ),
          ),
          // Right sidebar with profile and quick actions
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
                    colors: [AppTheme.textSecondaryColor, AppTheme.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.settings_rounded,
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
                      'User Preferences',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Customize your WAVE experience with personalized settings',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsStats(),
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

  Widget _buildSettingsStats() {
    return Row(
      children: [
        _buildStatCard('Active', '8', AppTheme.successColor),
        const SizedBox(width: 16),
        _buildStatCard('Customized', '12', AppTheme.primaryColor),
        const SizedBox(width: 16),
        _buildStatCard('Default', '4', AppTheme.textSecondaryColor),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
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
            '$value $label',
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
        _buildActionButton(Icons.restore, 'Reset'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.save, 'Save'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.download, 'Export'),
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

  Widget _buildSettingsContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSettingsSection('Notifications', Icons.notifications_rounded, _buildNotificationSettings()),
          const SizedBox(height: 24),
          _buildSettingsSection('Appearance', Icons.palette_rounded, _buildAppearanceSettings()),
          const SizedBox(height: 24),
          _buildSettingsSection('Data & Privacy', Icons.security_rounded, _buildPrivacySettings()),
          const SizedBox(height: 24),
          _buildSettingsSection('Performance', Icons.speed_rounded, _buildPerformanceSettings()),
          const SizedBox(height: 24),
          _buildSettingsSection('Account', Icons.account_circle_rounded, _buildAccountSettings()),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, Widget content) {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              border: const Border(
                bottom: BorderSide(color: AppTheme.borderColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        _buildSwitchSetting('Email Notifications', 'Receive alerts via email', _emailNotifications, (value) {
          setState(() {
            _emailNotifications = value;
          });
        }),
        _buildSwitchSetting('Push Notifications', 'Receive push notifications on device', _pushNotifications, (value) {
          setState(() {
            _pushNotifications = value;
          });
        }),
        _buildSwitchSetting('SMS Alerts', 'Receive critical alerts via SMS', _smsAlerts, (value) {
          setState(() {
            _smsAlerts = value;
          });
        }),
        _buildSwitchSetting('Auto-dismiss Low Priority', 'Automatically dismiss low priority alerts', _autoDismissLowPriority, (value) {
          setState(() {
            _autoDismissLowPriority = value;
          });
        }),
        const SizedBox(height: 16),
        _buildDropdownSetting('Update Frequency', 'How often to check for new data', _selectedUpdateFrequency, _updateFrequencies, (value) {
          setState(() {
            _selectedUpdateFrequency = value!;
          });
        }),
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return Column(
      children: [
        _buildDropdownSetting('Theme', 'Choose your preferred theme', _selectedTheme, _themes, (value) {
          setState(() {
            _selectedTheme = value!;
          });
        }),
        _buildDropdownSetting('Language', 'Select your preferred language', _selectedLanguage, _languages, (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        }),
        _buildSwitchSetting('Animations', 'Enable smooth animations and transitions', _animationsEnabled, (value) {
          setState(() {
            _animationsEnabled = value;
          });
        }),
        _buildSwitchSetting('Sound Effects', 'Play sounds for interactions and alerts', _soundEffects, (value) {
          setState(() {
            _soundEffects = value;
          });
        }),
        _buildSwitchSetting('Haptic Feedback', 'Vibrate on touch interactions', _hapticFeedback, (value) {
          setState(() {
            _hapticFeedback = value;
          });
        }),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return Column(
      children: [
        _buildSwitchSetting('Data Collection', 'Allow anonymous data collection for improvements', true, (value) {
          // Handle data collection toggle
        }),
        _buildSwitchSetting('Analytics', 'Share usage analytics with WAVE team', true, (value) {
          // Handle analytics toggle
        }),
        _buildSwitchSetting('Crash Reports', 'Automatically send crash reports', true, (value) {
          // Handle crash reports toggle
        }),
        const SizedBox(height: 16),
        _buildActionSetting('Clear Cache', 'Remove cached data to free up space', Icons.delete_outline, () {
          _showClearCacheDialog();
        }),
        _buildActionSetting('Export Data', 'Download your data and settings', Icons.download, () {
          _exportData();
        }),
        _buildActionSetting('Delete Account', 'Permanently delete your account', Icons.delete_forever, () {
          _showDeleteAccountDialog();
        }),
      ],
    );
  }

  Widget _buildPerformanceSettings() {
    return Column(
      children: [
        _buildDropdownSetting('Globe Quality', 'Balance between quality and performance', _selectedQuality, _qualities, (value) {
          setState(() {
            _selectedQuality = value!;
          });
        }),
        _buildSwitchSetting('Background Updates', 'Update data when app is in background', true, (value) {
          // Handle background updates toggle
        }),
        _buildSwitchSetting('Auto-save', 'Automatically save your work', true, (value) {
          // Handle auto-save toggle
        }),
        const SizedBox(height: 16),
        _buildActionSetting('Clear Storage', 'Free up storage space', Icons.storage, () {
          _showClearStorageDialog();
        }),
        _buildActionSetting('Reset Performance', 'Reset all performance settings to default', Icons.refresh, () {
          _resetPerformanceSettings();
        }),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        _buildActionSetting('Edit Profile', 'Update your personal information', Icons.edit, () {
          _editProfile();
        }),
        _buildActionSetting('Change Password', 'Update your account password', Icons.lock, () {
          _changePassword();
        }),
        _buildActionSetting('Two-Factor Authentication', 'Add extra security to your account', Icons.security, () {
          _setupTwoFactor();
        }),
        _buildActionSetting('Connected Accounts', 'Manage linked social accounts', Icons.link, () {
          _manageConnectedAccounts();
        }),
        const SizedBox(height: 16),
        _buildActionSetting('Sign Out', 'Sign out of your account', Icons.logout, () {
          _signOut();
        }),
      ],
    );
  }

  Widget _buildSwitchSetting(String title, String description, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String description, String value, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(String title, String description, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
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
          _buildProfileSection(),
          _buildQuickStatsSection(),
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Research Scientist',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _editProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
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
            'Quick Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatItem('Sessions', '24', AppTheme.primaryColor),
          _buildStatItem('Data Points', '1.2K', AppTheme.accentColor),
          _buildStatItem('Alerts', '8', AppTheme.warningColor),
          _buildStatItem('Collaborations', '12', AppTheme.secondaryColor),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support & Help',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSupportItem('Help Center', Icons.help_outline),
            _buildSupportItem('Contact Support', Icons.support_agent),
            _buildSupportItem('Report Bug', Icons.bug_report),
            _buildSupportItem('Feature Request', Icons.lightbulb_outline),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendFeedback();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
              ),
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Handle support item tap
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.textSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action methods
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export started'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Storage'),
        content: const Text('This will free up storage space by removing temporary files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Storage cleared successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _resetPerformanceSettings() {
    setState(() {
      _selectedQuality = 'High';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Performance settings reset to default'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile functionality will be implemented'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change password functionality will be implemented'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _setupTwoFactor() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Two-factor authentication setup will be implemented'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _manageConnectedAccounts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connected accounts management will be implemented'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback form will be opened'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }
}
