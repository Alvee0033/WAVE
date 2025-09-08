import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ARVRPage extends StatefulWidget {
  const ARVRPage({super.key});

  @override
  State<ARVRPage> createState() => _ARVRPageState();
}

class _ARVRPageState extends State<ARVRPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isARSupported = true;
  bool _isVRSupported = false;
  bool _isARActive = false;
  bool _isVRActive = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkDeviceCapabilities();
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

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _checkDeviceCapabilities() {
    // Simulate device capability check
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isARSupported = true; // Assume AR is supported
        _isVRSupported = false; // Assume VR is not supported on this device
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.accentColor, AppTheme.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.view_in_ar_rounded,
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
                      'Immersive Experiences',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AR and VR experiences for immersive Earth data exploration',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCapabilityStatus(),
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

  Widget _buildCapabilityStatus() {
    return Row(
      children: [
        _buildCapabilityIndicator('AR', _isARSupported, AppTheme.accentColor),
        const SizedBox(width: 16),
        _buildCapabilityIndicator('VR', _isVRSupported, AppTheme.secondaryColor),
        const SizedBox(width: 16),
        _buildCapabilityIndicator('Hand Tracking', true, AppTheme.primaryColor),
      ],
    );
  }

  Widget _buildCapabilityIndicator(String label, bool isSupported, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSupported ? color : AppTheme.textSecondaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSupported ? color : AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionButton(Icons.help_outline, 'Help'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.settings, 'Settings'),
        const SizedBox(width: 12),
        _buildActionButton(Icons.info_outline, 'Info'),
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

  Widget _buildMainContent() {
    return Row(
      children: [
        // AR Experience
        Expanded(
          child: _buildARSection(),
        ),
        const SizedBox(width: 24),
        // VR Experience
        Expanded(
          child: _buildVRSection(),
        ),
      ],
    );
  }

  Widget _buildARSection() {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          _buildSectionHeader('Augmented Reality', Icons.view_in_ar_rounded, AppTheme.accentColor),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: _buildARPreview(),
                  ),
                  const SizedBox(height: 20),
                  _buildARControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVRSection() {
    return Container(
      decoration: AppTheme.modernCardDecoration(),
      child: Column(
        children: [
          _buildSectionHeader('Virtual Reality', Icons.view_in_ar, AppTheme.secondaryColor),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: _buildVRPreview(),
                  ),
                  const SizedBox(height: 20),
                  _buildVRControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: const Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _isARSupported ? 'SUPPORTED' : 'NOT SUPPORTED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Stack(
        children: [
          // AR Preview Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.accentColor.withOpacity(0.3),
                              AppTheme.accentColor.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.public,
                          color: AppTheme.accentColor,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'AR Earth Model',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Place on any flat surface',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          // AR Status overlay
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isARActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isARActive ? 'ACTIVE' : 'INACTIVE',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVRPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Stack(
        children: [
          // VR Preview Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.secondaryColor.withOpacity(0.3),
                        AppTheme.secondaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.view_in_ar,
                    color: AppTheme.secondaryColor,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'VR Environment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Immersive 360° experience',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          // VR Status overlay
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isVRActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isVRActive ? 'ACTIVE' : 'INACTIVE',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARControls() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isARSupported ? () => _toggleAR() : null,
                icon: Icon(_isARActive ? Icons.stop : Icons.play_arrow),
                label: Text(_isARActive ? 'Stop AR' : 'Start AR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showARSettings(),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildARFeatures(),
      ],
    );
  }

  Widget _buildVRControls() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isVRSupported ? () => _toggleVR() : null,
                icon: Icon(_isVRActive ? Icons.stop : Icons.play_arrow),
                label: Text(_isVRActive ? 'Stop VR' : 'Start VR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showVRSettings(),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildVRFeatures(),
      ],
    );
  }

  Widget _buildARFeatures() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AR Features',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('3D Earth Model', true),
          _buildFeatureItem('Data Layer Overlay', true),
          _buildFeatureItem('Hand Tracking', true),
          _buildFeatureItem('Voice Commands', false),
        ],
      ),
    );
  }

  Widget _buildVRFeatures() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VR Features',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('360° Environment', false),
          _buildFeatureItem('Hand Tracking', false),
          _buildFeatureItem('Voice Commands', false),
          _buildFeatureItem('Multi-user VR', false),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isAvailable ? AppTheme.successColor : AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            feature,
            style: TextStyle(
              fontSize: 12,
              color: isAvailable ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
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
          _buildDeviceInfoSection(),
          _buildTutorialSection(),
          _buildSupportSection(),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoSection() {
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
            'Device Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildDeviceInfoItem('AR Support', _isARSupported ? 'Supported' : 'Not Supported', _isARSupported),
          _buildDeviceInfoItem('VR Support', _isVRSupported ? 'Supported' : 'Not Supported', _isVRSupported),
          _buildDeviceInfoItem('Camera', 'Available', true),
          _buildDeviceInfoItem('Gyroscope', 'Available', true),
          _buildDeviceInfoItem('Accelerometer', 'Available', true),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoItem(String label, String value, bool isSupported) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
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
              color: isSupported ? AppTheme.successColor : AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSection() {
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
            'Tutorials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildTutorialItem('Getting Started with AR', Icons.play_circle_outline),
          _buildTutorialItem('VR Setup Guide', Icons.view_in_ar),
          _buildTutorialItem('Hand Gestures', Icons.gesture),
          _buildTutorialItem('Voice Commands', Icons.mic),
        ],
      ),
    );
  }

  Widget _buildTutorialItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Handle tutorial tap
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
                color: AppTheme.primaryColor,
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

  Widget _buildSupportSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildSupportItem('Report Issue', Icons.bug_report),
            _buildSupportItem('Contact Support', Icons.support_agent),
            _buildSupportItem('FAQ', Icons.help_outline),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle feedback
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

  void _toggleAR() {
    setState(() {
      _isARActive = !_isARActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isARActive ? 'AR session started' : 'AR session stopped'),
        backgroundColor: _isARActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
      ),
    );
  }

  void _toggleVR() {
    setState(() {
      _isVRActive = !_isVRActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isVRActive ? 'VR session started' : 'VR session stopped'),
        backgroundColor: _isVRActive ? AppTheme.successColor : AppTheme.textSecondaryColor,
      ),
    );
  }

  void _showARSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AR Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('AR settings will be available here'),
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

  void _showVRSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('VR Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('VR settings will be available here'),
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
}
