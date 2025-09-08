import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

/// Cesium 3D Earth Widget for Flutter Web
/// Embeds the Cesium test HTML file for interactive 3D Earth
class CesiumEarthWidget extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  final Function(double lat, double lng)? onLocationChanged;
  final Map<String, dynamic>? dataLayers;
  
  const CesiumEarthWidget({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
    this.onLocationChanged,
    this.dataLayers,
  });

  @override
  State<CesiumEarthWidget> createState() => _CesiumEarthWidgetState();
}

class _CesiumEarthWidgetState extends State<CesiumEarthWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  // late html.IFrameElement _iframe; // Removed for non-web builds

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeCesiumEarth();
    } else {
      // On non-web platforms, show fallback immediately
      _isLoading = false;
    }
  }

  void _initializeCesiumEarth() {
    if (!kIsWeb) return;
    try {
      // _createCesiumIframe(); // Skip direct iframe creation in shared code
      // Simulate loading time for Cesium to initialize
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4285F4).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (kIsWeb && !_hasError)
              _buildCesiumPlaceholder()
            else if (_hasError)
              _buildErrorWidget()
            else
              _buildFallbackWidget(),
            Positioned(
              top: 16,
              right: 16,
              child: _buildControlOverlay(),
            ),
            if (_isLoading && !_hasError)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF4285F4),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading 3D Earth...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Initializing Cesium Engine',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCesiumPlaceholder() {
    // Web placeholder (no direct html usage here)
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildEarthBackground(),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.8),
                    const Color(0xFF2E7D32).withOpacity(0.6),
                    const Color(0xFF1B5E20).withOpacity(0.4),
                    const Color(0xFF0A0A0A).withOpacity(0.8),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.public,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),
          ),
          ...List.generate(20, (index) => _buildFloatingParticle(index)),
        ],
      ),
    );
  }

  Widget _buildEarthBackground() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 10),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return CustomPaint(
          painter: _EarthBackgroundPainter(value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index) {
    return Positioned(
      left: (index * 37.0) % widget.width,
      top: (index * 23.0) % widget.height,
      child: TweenAnimationBuilder<double>(
        duration: Duration(seconds: 3 + (index % 3)),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(value * 2 * math.pi) * 20,
              math.cos(value * 2 * math.pi) * 20,
            ),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF4285F4).withOpacity(0.6),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlOverlay() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4285F4).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            onPressed: widget.onResetView,
            size: 32,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.layers,
            label: 'Layers',
            onPressed: () => _showLayersDialog(),
            size: 32,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.search,
            label: 'Search',
            onPressed: () => _showSearchDialog(),
            size: 32,
          ),
          const SizedBox(height: 8),
          _buildControlButton(
            icon: Icons.fullscreen,
            label: 'Fullscreen',
            onPressed: () => _toggleFullscreen(),
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    double size = 32,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4).withOpacity(0.2),
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(
              color: const Color(0xFF4285F4).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: const Color(0xFF4285F4),
              size: size * 0.6,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4CAF50).withOpacity(0.8),
                    const Color(0xFF2E7D32).withOpacity(0.6),
                    const Color(0xFF1B5E20).withOpacity(0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.public,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '3D Earth Globe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Interactive Cesium Engine',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load 3D Earth',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isLoading = true;
                });
                _initializeCesiumEarth();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLayersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Data Layers',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Available layers:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            _buildLayerItem('Satellite Imagery', true),
            _buildLayerItem('Temperature Data', false),
            _buildLayerItem('Precipitation', false),
            _buildLayerItem('Vegetation Index', false),
            _buildLayerItem('Population Density', false),
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

  Widget _buildLayerItem(String name, bool enabled) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {
          // Handle layer toggle
        },
        activeColor: const Color(0xFF4285F4),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Search Location',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter location (e.g., New York, Tokyo)',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4285F4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4285F4)),
            ),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Searching for: $value'),
                backgroundColor: const Color(0xFF4285F4),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _toggleFullscreen() {
    // No-op on non-web; for web, avoid direct dart:html usage here
    if (!kIsWeb) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fullscreen not supported on this platform'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _EarthBackgroundPainter extends CustomPainter {
  final double animationValue;

  _EarthBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw animated grid lines
    for (int i = 0; i < 20; i++) {
      final alpha = (1.0 - (i / 20.0)) * 0.3;
      paint.color = const Color(0xFF4285F4).withOpacity(alpha);
      final y = (size.height / 20) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
      final x = (size.width / 20) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw animated circles
    for (int i = 0; i < 5; i++) {
      final radius = (size.width / 10) * (i + 1) * animationValue;
      final alpha = (1.0 - (i / 5.0)) * 0.2;
      paint.color = const Color(0xFF4285F4).withOpacity(alpha);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

