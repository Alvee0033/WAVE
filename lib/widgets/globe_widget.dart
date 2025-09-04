import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class GlobeWidget extends StatefulWidget {
  const GlobeWidget({super.key});

  @override
  State<GlobeWidget> createState() => _GlobeWidgetState();
}

class _GlobeWidgetState extends State<GlobeWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _scale = 1.0;
  
  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return GestureDetector(
          onPanUpdate: appState.globeInteractionEnabled ? _onPanUpdate : null,
          onScaleUpdate: appState.globeInteractionEnabled ? _onScaleUpdate : null,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF0F0F23),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Stars background
                ...List.generate(100, (index) => _buildStar(index)),
                
                // Main Globe
                Center(
                  child: AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_rotationX)
                          ..rotateY(_rotationY + _rotationController.value * 2 * math.pi)
                          ..scale(_scale),
                        child: _buildGlobe(appState),
                      );
                    },
                  ),
                ),
                
                // Data layer overlays
                ..._buildDataLayerOverlays(appState),
                
                // Interaction hints
                if (appState.globeInteractionEnabled)
                  _buildInteractionHints(),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildGlobe(AppState appState) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 1.2,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF2E5BBA),
            Color(0xFF1E3A8A),
            Color(0xFF0F172A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Continents overlay
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: CustomPaint(
              size: const Size(300, 300),
              painter: ContinentsPainter(),
            ),
          ),
          
          // Atmosphere glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStar(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 2 + 1;
    final opacity = random.nextDouble() * 0.8 + 0.2;
    
    return Positioned(
      left: random.nextDouble() * 400,
      top: random.nextDouble() * 800,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = math.sin(_pulseController.value * 2 * math.pi + index) * 0.3 + 0.7;
          return Opacity(
            opacity: opacity * pulse,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: size,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  List<Widget> _buildDataLayerOverlays(AppState appState) {
    List<Widget> overlays = [];
    
    appState.dataLayers.forEach((key, layer) {
      if (layer.enabled) {
        overlays.add(
          Positioned(
            left: 50 + (overlays.length * 60.0),
            top: 100,
            child: _buildDataPoint(layer),
          ),
        );
      }
    });
    
    return overlays;
  }
  
  Widget _buildDataPoint(DataLayer layer) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulse = math.sin(_pulseController.value * 2 * math.pi) * 0.2 + 0.8;
        return Transform.scale(
          scale: pulse,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: layer.color.withOpacity(layer.opacity),
              boxShadow: [
                BoxShadow(
                  color: layer.color.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInteractionHints() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🌍 Drag to rotate',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '🔍 Pinch to zoom',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationY += details.delta.dx * 0.01;
      _rotationX -= details.delta.dy * 0.01;
      _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
    });
  }
  
  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (details.scale * _scale).clamp(0.5, 3.0);
    });
  }
}

class ContinentsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D5016)
      ..style = PaintingStyle.fill;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Simplified continent shapes
    // North America
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.2),
      radius * 0.15,
      paint,
    );
    
    // South America
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy + radius * 0.3),
      radius * 0.1,
      paint,
    );
    
    // Africa
    canvas.drawCircle(
      Offset(center.dx + radius * 0.1, center.dy),
      radius * 0.12,
      paint,
    );
    
    // Europe
    canvas.drawCircle(
      Offset(center.dx + radius * 0.05, center.dy - radius * 0.25),
      radius * 0.08,
      paint,
    );
    
    // Asia
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy - radius * 0.1),
      radius * 0.18,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}