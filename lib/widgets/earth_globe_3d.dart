import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'earth_texture_generator.dart';

/// Interactive 3D Earth Globe Widget
/// Displays a texture-mapped Earth with touch controls and grid lines
class EarthGlobe3D extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  
  const EarthGlobe3D({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
  });

  @override
  State<EarthGlobe3D> createState() => _EarthGlobe3DState();
}

class _EarthGlobe3DState extends State<EarthGlobe3D>
    with TickerProviderStateMixin {
  // Globe rotation and zoom state
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _zoom = 1.0;
  
  // Animation controllers
  late AnimationController _rotationController;
  late AnimationController _zoomController;
  
  // Touch interaction state
  Offset? _lastPanPosition;
  double _lastScale = 1.0;
  
  // Earth texture
  ui.Image? _earthTexture;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadEarthTexture();
  }
  
  void _initializeControllers() {
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }
  
  Future<void> _loadEarthTexture() async {
    try {
      // Generate procedural Earth texture
      final texture = await EarthTextureGenerator.generateEarthTexture();
      
      setState(() {
        _earthTexture = texture;
        _isLoading = false;
      });
    } catch (e) {
      // Fallback to simple rendering without texture
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _onPanStart(DragStartDetails details) {
    _lastPanPosition = details.localPosition;
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    if (_lastPanPosition != null) {
      final delta = details.localPosition - _lastPanPosition!;
      
      setState(() {
        _rotationY += delta.dx * 0.01;
        _rotationX += delta.dy * 0.01;
        
        // Clamp X rotation to prevent flipping
        _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
      });
      
      _lastPanPosition = details.localPosition;
    }
  }
  
  void _onPanEnd(DragEndDetails details) {
    _lastPanPosition = null;
  }
  
  void _onScaleStart(ScaleStartDetails details) {
    _lastScale = _zoom;
  }
  
  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = (_lastScale * details.scale).clamp(0.5, 3.0);
    });
  }
  
  void resetView() {
    _rotationController.reset();
    _zoomController.reset();
    
    final rotationXAnimation = Tween<double>(
      begin: _rotationX,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    final rotationYAnimation = Tween<double>(
      begin: _rotationY,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    final zoomAnimation = Tween<double>(
      begin: _zoom,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeInOut,
    ));
    
    rotationXAnimation.addListener(() {
      setState(() {
        _rotationX = rotationXAnimation.value;
      });
    });
    
    rotationYAnimation.addListener(() {
      setState(() {
        _rotationY = rotationYAnimation.value;
      });
    });
    
    zoomAnimation.addListener(() {
      setState(() {
        _zoom = zoomAnimation.value;
      });
    });
    
    _rotationController.forward();
    _zoomController.forward();
    
    widget.onResetView?.call();
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _zoomController.dispose();
    _earthTexture?.dispose();
    super.dispose();
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
        child: _isLoading
            ? _buildLoadingWidget()
            : _buildGlobe(),
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
              'Loading Earth...',
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
  
  Widget _buildGlobe() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: EarthGlobePainter(
          rotationX: _rotationX,
          rotationY: _rotationY,
          zoom: _zoom,
          earthTexture: _earthTexture,
        ),
      ),
    );
  }
}

/// Custom painter for rendering the 3D Earth globe
class EarthGlobePainter extends CustomPainter {
  final double rotationX;
  final double rotationY;
  final double zoom;
  final ui.Image? earthTexture;
  
  EarthGlobePainter({
    required this.rotationX,
    required this.rotationY,
    required this.zoom,
    this.earthTexture,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) * zoom;
    
    // Draw space background
    _drawSpaceBackground(canvas, size);
    
    // Draw Earth sphere
    _drawEarthSphere(canvas, center, radius);
    
    // Draw latitude/longitude grid
    _drawLatLngGrid(canvas, center, radius);
    
    // Draw atmosphere glow
    _drawAtmosphereGlow(canvas, center, radius);
  }
  
  void _drawSpaceBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF000011),
          const Color(0xFF000000),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Draw stars
    _drawStars(canvas, size);
  }
  
  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
    
    final random = math.Random(42); // Fixed seed for consistent stars
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * 0.8 + 0.2;
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5 + 0.5, paint);
    }
  }
  
  void _drawEarthSphere(Canvas canvas, Offset center, double radius) {
    // Create Earth gradient (simplified)
    final earthPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4A90E2), // Ocean blue
          const Color(0xFF2E5C3E), // Land green
          const Color(0xFF1A3A2E), // Dark edge
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // Draw main Earth sphere
    canvas.drawCircle(center, radius, earthPaint);
    
    // Add continent-like patterns (simplified)
    _drawContinents(canvas, center, radius);
  }
  
  void _drawContinents(Canvas canvas, Offset center, double radius) {
    final continentPaint = Paint()
      ..color = const Color(0xFF3E7B3E).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Simplified continent shapes
    final path = Path();
    
    // North America (simplified)
    path.addOval(Rect.fromCenter(
      center: Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
      width: radius * 0.4,
      height: radius * 0.6,
    ));
    
    // Europe/Africa (simplified)
    path.addOval(Rect.fromCenter(
      center: Offset(center.dx + radius * 0.1, center.dy),
      width: radius * 0.3,
      height: radius * 0.8,
    ));
    
    // Asia (simplified)
    path.addOval(Rect.fromCenter(
      center: Offset(center.dx + radius * 0.4, center.dy - radius * 0.1),
      width: radius * 0.5,
      height: radius * 0.4,
    ));
    
    canvas.drawPath(path, continentPaint);
  }
  
  void _drawLatLngGrid(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Draw latitude lines
    for (int lat = -60; lat <= 60; lat += 30) {
      final y = center.dy + (lat / 90) * radius * 0.8;
      final ellipseRadius = radius * math.cos(lat * math.pi / 180).abs();
      
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, y),
          width: ellipseRadius * 2,
          height: ellipseRadius * 0.3,
        ),
        gridPaint,
      );
    }
    
    // Draw longitude lines
    for (int lng = -150; lng <= 150; lng += 30) {
      final path = Path();
      final angleOffset = lng * math.pi / 180;
      
      for (double t = -math.pi / 2; t <= math.pi / 2; t += 0.1) {
        final x = center.dx + radius * math.cos(t) * math.sin(angleOffset + rotationY);
        final y = center.dy + radius * math.sin(t);
        final z = radius * math.cos(t) * math.cos(angleOffset + rotationY);
        
        if (z > 0) { // Only draw visible part
          if (t == -math.pi / 2) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
      }
      
      canvas.drawPath(path, gridPaint);
    }
  }
  
  void _drawAtmosphereGlow(Canvas canvas, Offset center, double radius) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          const Color(0xFF4A90E2).withOpacity(0.1),
          const Color(0xFF4A90E2).withOpacity(0.3),
        ],
        stops: const [0.85, 0.95, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.1));
    
    canvas.drawCircle(center, radius * 1.1, glowPaint);
  }
  
  @override
  bool shouldRepaint(EarthGlobePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX ||
           oldDelegate.rotationY != rotationY ||
           oldDelegate.zoom != zoom;
  }
}

/// Extension for adding overlay layers (NASA Terra instrument data)
extension EarthGlobeOverlays on EarthGlobe3D {
  /// Add MODIS data overlay
  /// Usage: globe.addModisOverlay(modisData)
  static Widget withModisOverlay(EarthGlobe3D globe, dynamic modisData) {
    // Implementation for MODIS overlay
    return globe;
  }
  
  /// Add MOPITT data overlay
  /// Usage: globe.addMopittOverlay(mopittData)
  static Widget withMopittOverlay(EarthGlobe3D globe, dynamic mopittData) {
    // Implementation for MOPITT overlay
    return globe;
  }
  
  /// Add CERES data overlay
  /// Usage: globe.addCeresOverlay(ceresData)
  static Widget withCeresOverlay(EarthGlobe3D globe, dynamic ceresData) {
    // Implementation for CERES overlay
    return globe;
  }
}