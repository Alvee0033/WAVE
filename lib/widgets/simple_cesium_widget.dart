import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Simple Cesium Widget that works on all platforms
/// For web: Shows a placeholder with link to working HTML version
/// For mobile: Shows a placeholder (can be extended later)
class SimpleCesiumWidget extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  final Function(double lat, double lng)? onLocationChanged;
  final Map<String, dynamic>? dataLayers;
  
  const SimpleCesiumWidget({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
    this.onLocationChanged,
    this.dataLayers,
  });

  @override
  State<SimpleCesiumWidget> createState() => _SimpleCesiumWidgetState();
}

class _SimpleCesiumWidgetState extends State<SimpleCesiumWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading
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
        child: _isLoading ? _buildLoadingWidget() : _buildGlobeWidget(),
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
              color: Color(0xFF2196F3),
            ),
            SizedBox(height: 16),
            Text(
              'Loading 3D Globe...',
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

  Widget _buildGlobeWidget() {
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
          // Animated Earth-like background
          _buildAnimatedBackground(),
          
          // Content overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Earth icon with animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 3),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 2 * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF2196F3).withOpacity(0.8),
                              const Color(0xFF1976D2).withOpacity(0.6),
                              const Color(0xFF0D47A1).withOpacity(0.4),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2196F3).withOpacity(0.3),
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
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Title
                const Text(
                  '3D Earth Globe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  kIsWeb ? 'Web Platform' : 'Mobile Platform',
                  style: const TextStyle(
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
                      icon: Icons.zoom_in,
                      label: 'Zoom In',
                      onPressed: () {
                        // Simulate zoom in
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zoom In')),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildControlButton(
                      icon: Icons.zoom_out,
                      label: 'Zoom Out',
                      onPressed: () {
                        // Simulate zoom out
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zoom Out')),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Test link for web
                if (kIsWeb)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Open the working HTML test in new tab
                      _openTestPage();
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open Working 3D Globe'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
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

  Widget _buildAnimatedBackground() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 10),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return CustomPaint(
          painter: _GlobeBackgroundPainter(value),
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
            color: const Color(0xFF2196F3).withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: const Color(0xFF2196F3),
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

  void _openTestPage() {
    if (kIsWeb) {
      // This would open the test page in a new tab
      // For now, just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Working 3D Globe available at: http://localhost:8080/cesium_test.html'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}

class _GlobeBackgroundPainter extends CustomPainter {
  final double animationValue;

  _GlobeBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw animated grid lines
    for (int i = 0; i < 20; i++) {
      final alpha = (1.0 - (i / 20.0)) * 0.3;
      paint.color = const Color(0xFF2196F3).withOpacity(alpha);
      
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
      paint.color = const Color(0xFF2196F3).withOpacity(alpha);
      
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


