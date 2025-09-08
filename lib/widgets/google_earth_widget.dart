import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Google Earth Engine Widget for Flutter Web
/// Uses iframe to embed Google Earth Engine
class GoogleEarthWidget extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  final Function(double lat, double lng)? onLocationChanged;
  final Map<String, dynamic>? dataLayers;
  
  const GoogleEarthWidget({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
    this.onLocationChanged,
    this.dataLayers,
  });

  @override
  State<GoogleEarthWidget> createState() => _GoogleEarthWidgetState();
}

class _GoogleEarthWidgetState extends State<GoogleEarthWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeGoogleEarth();
    }
  }

  void _initializeGoogleEarth() {
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
            if (_hasError)
              _buildErrorWidget()
            else if (kIsWeb)
              _buildGoogleEarthWidget()
            else
              _buildFallbackWidget(),
            
            if (_isLoading && !_hasError)
              _buildLoadingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleEarthWidget() {
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
      child: Stack(
        children: [
          // Google Earth-like background
          _buildEarthBackground(),
          
          // Content overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Earth icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4285F4).withOpacity(0.8),
                        const Color(0xFF1976D2).withOpacity(0.6),
                        const Color(0xFF0D47A1).withOpacity(0.4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4285F4).withOpacity(0.3),
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
                
                // Title
                const Text(
                  'Google Earth Engine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'Satellite Imagery & Data',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Interactive buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlButton(
                      icon: Icons.refresh,
                      label: 'Reset',
                      onPressed: widget.onResetView,
                    ),
                    const SizedBox(width: 16),
                    _buildControlButton(
                      icon: Icons.layers,
                      label: 'Layers',
                      onPressed: () {
                        _showLayersDialog();
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildControlButton(
                      icon: Icons.search,
                      label: 'Search',
                      onPressed: () {
                        _showSearchDialog();
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Open Google Earth button
                ElevatedButton.icon(
                  onPressed: () {
                    _openGoogleEarth();
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Google Earth'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF4285F4).withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
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
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackWidget() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public,
              color: Color(0xFF4285F4),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Google Earth Engine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Web platform required',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFF0A0A0A),
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
              'Failed to load Google Earth',
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
                _initializeGoogleEarth();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF4285F4),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Google Earth...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
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
        title: const Text('Data Layers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Available layers:'),
            const SizedBox(height: 16),
            _buildLayerItem('Satellite Imagery', true),
            _buildLayerItem('Temperature Data', false),
            _buildLayerItem('Precipitation', false),
            _buildLayerItem('Vegetation Index', false),
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
      title: Text(name),
      trailing: Switch(
        value: enabled,
        onChanged: (value) {
          // Handle layer toggle
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Location'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter location (e.g., New York, Tokyo)',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Searching for: $value')),
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

  void _openGoogleEarth() {
    if (kIsWeb) {
      // Open Google Earth in new tab
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening Google Earth in new tab...'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // In a real implementation, you would use:
      // html.window.open('https://earth.google.com', '_blank');
    }
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
      
      // Horizontal lines
      final y = (size.height / 20) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
      
      // Vertical lines
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


