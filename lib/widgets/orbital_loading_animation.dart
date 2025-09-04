import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class OrbitalLoadingAnimation extends StatefulWidget {
  const OrbitalLoadingAnimation({super.key});

  @override
  State<OrbitalLoadingAnimation> createState() => _OrbitalLoadingAnimationState();
}

class _OrbitalLoadingAnimationState extends State<OrbitalLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer orbit
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                
                // Middle orbit
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                
                // Inner orbit
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.7),
                      width: 1,
                    ),
                  ),
                ),
                
                // Center Earth
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // Orbiting dots
                _buildOrbitingDot(0, 40, AppTheme.primaryColor),
                _buildOrbitingDot(math.pi / 2, 30, AppTheme.secondaryColor),
                _buildOrbitingDot(math.pi, 35, AppTheme.modisColor),
                _buildOrbitingDot(3 * math.pi / 2, 25, AppTheme.asterColor),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildOrbitingDot(double offset, double radius, Color color) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final angle = (_rotationController.value * 2 * math.pi) + offset;
        final x = radius * math.cos(angle);
        final y = radius * math.sin(angle);
        
        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}