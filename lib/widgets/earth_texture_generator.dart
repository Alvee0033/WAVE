import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Generates a procedural Earth texture for the 3D globe
class EarthTextureGenerator {
  static const int textureWidth = 512;
  static const int textureHeight = 256;
  
  /// Generates a procedural Earth texture image
  static Future<ui.Image> generateEarthTexture() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(textureWidth.toDouble(), textureHeight.toDouble());
    
    // Draw the Earth texture
    _drawEarthTexture(canvas, size);
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(textureWidth, textureHeight);
    picture.dispose();
    
    return image;
  }
  
  static void _drawEarthTexture(Canvas canvas, Size size) {
    // Ocean background
    final oceanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4A90E2), // Light blue
          const Color(0xFF2E5C8A), // Medium blue
          const Color(0xFF1A3A5C), // Dark blue
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), oceanPaint);
    
    // Draw continents
    _drawContinents(canvas, size);
    
    // Draw polar ice caps
    _drawPolarIceCaps(canvas, size);
    
    // Add cloud patterns
    _drawClouds(canvas, size);
    
    // Add grid lines
    _drawGridLines(canvas, size);
  }
  
  static void _drawContinents(Canvas canvas, Size size) {
    final landPaint = Paint()
      ..color = const Color(0xFF6B8E23) // Olive green
      ..style = PaintingStyle.fill;
    
    final mountainPaint = Paint()
      ..color = const Color(0xFF8B4513) // Saddle brown
      ..style = PaintingStyle.fill;
    
    // North America
    final northAmerica = Path()
      ..moveTo(size.width * 0.15, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.25, size.height * 0.20,
        size.width * 0.35, size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.40, size.height * 0.45,
        size.width * 0.35, size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.25, size.height * 0.60,
        size.width * 0.15, size.height * 0.50,
      )
      ..close();
    
    canvas.drawPath(northAmerica, landPaint);
    
    // South America
    final southAmerica = Path()
      ..moveTo(size.width * 0.28, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.35, size.height * 0.50,
        size.width * 0.38, size.height * 0.65,
      )
      ..quadraticBezierTo(
        size.width * 0.40, size.height * 0.80,
        size.width * 0.35, size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * 0.30, size.height * 0.95,
        size.width * 0.25, size.height * 0.85,
      )
      ..quadraticBezierTo(
        size.width * 0.22, size.height * 0.70,
        size.width * 0.28, size.height * 0.55,
      )
      ..close();
    
    canvas.drawPath(southAmerica, landPaint);
    
    // Europe
    final europe = Path()
      ..moveTo(size.width * 0.47, size.height * 0.25)
      ..quadraticBezierTo(
        size.width * 0.55, size.height * 0.22,
        size.width * 0.60, size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.62, size.height * 0.38,
        size.width * 0.58, size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.50, size.height * 0.45,
        size.width * 0.47, size.height * 0.38,
      )
      ..close();
    
    canvas.drawPath(europe, landPaint);
    
    // Africa
    final africa = Path()
      ..moveTo(size.width * 0.48, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.58, size.height * 0.40,
        size.width * 0.62, size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.65, size.height * 0.70,
        size.width * 0.60, size.height * 0.85,
      )
      ..quadraticBezierTo(
        size.width * 0.55, size.height * 0.90,
        size.width * 0.50, size.height * 0.85,
      )
      ..quadraticBezierTo(
        size.width * 0.45, size.height * 0.65,
        size.width * 0.48, size.height * 0.42,
      )
      ..close();
    
    canvas.drawPath(africa, landPaint);
    
    // Asia
    final asia = Path()
      ..moveTo(size.width * 0.60, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * 0.80, size.height * 0.18,
        size.width * 0.90, size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.95, size.height * 0.45,
        size.width * 0.88, size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.75, size.height * 0.60,
        size.width * 0.65, size.height * 0.50,
      )
      ..quadraticBezierTo(
        size.width * 0.58, size.height * 0.35,
        size.width * 0.60, size.height * 0.20,
      )
      ..close();
    
    canvas.drawPath(asia, landPaint);
    
    // Australia
    final australia = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.82, size.height * 0.75),
        width: size.width * 0.12,
        height: size.height * 0.08,
      ));
    
    canvas.drawPath(australia, landPaint);
    
    // Add mountain ranges
    _drawMountainRanges(canvas, size, mountainPaint);
  }
  
  static void _drawMountainRanges(Canvas canvas, Size size, Paint mountainPaint) {
    // Rocky Mountains
    final rockies = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.22, size.height * 0.35),
        width: size.width * 0.08,
        height: size.height * 0.25,
      ));
    canvas.drawPath(rockies, mountainPaint);
    
    // Andes
    final andes = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.30, size.height * 0.70),
        width: size.width * 0.04,
        height: size.height * 0.35,
      ));
    canvas.drawPath(andes, mountainPaint);
    
    // Himalayas
    final himalayas = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.35),
        width: size.width * 0.15,
        height: size.height * 0.08,
      ));
    canvas.drawPath(himalayas, mountainPaint);
  }
  
  static void _drawPolarIceCaps(Canvas canvas, Size size) {
    final icePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          const Color(0xFFE6F3FF),
          const Color(0xFFB0E0E6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Arctic ice cap
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.12),
      icePaint,
    );
    
    // Antarctic ice cap
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.88, size.width, size.height * 0.12),
      icePaint,
    );
  }
  
  static void _drawClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final random = math.Random(42); // Fixed seed for consistent clouds
    
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = random.nextDouble() * 40 + 20;
      final height = random.nextDouble() * 15 + 8;
      
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: width,
          height: height,
        ),
        cloudPaint,
      );
    }
  }
  
  static void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Latitude lines
    for (int lat = -60; lat <= 60; lat += 30) {
      final y = size.height * (0.5 + lat / 180);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Longitude lines
    for (int lng = -150; lng <= 150; lng += 30) {
      final x = size.width * (0.5 + lng / 360);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }
}