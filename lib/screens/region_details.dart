import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/story_card.dart';

class RegionDetails extends StatefulWidget {
  final String regionId;
  
  const RegionDetails({
    super.key,
    required this.regionId,
  });

  @override
  State<RegionDetails> createState() => _RegionDetailsState();
}

class _RegionDetailsState extends State<RegionDetails>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Mock data for different regions
  late Map<String, dynamic> regionData;
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _loadRegionData();
    _fadeController.forward();
  }
  
  void _loadRegionData() {
    // Mock data based on region ID
    switch (widget.regionId) {
      case 'amazon':
        regionData = {
          'name': 'Amazon Basin',
          'description': 'The world\'s largest tropical rainforest',
          'coordinates': '3.4653°S, 62.2159°W',
          'area': '5.5 million km²',
          'stories': [
            {
              'title': 'Amazon Deforestation Story',
              'subtitle': 'Tracking forest loss over 25 years',
              'description': 'Satellite data reveals the dramatic changes in the Amazon rainforest from 1999 to 2024. MODIS vegetation indices show significant forest loss in key areas, particularly along the arc of deforestation.',
              'dataPoints': [
                'Forest cover decreased by 15% since 2000',
                'Peak deforestation occurred in 2004',
                'Recent conservation efforts show promise',
              ],
              'color': AppTheme.modisColor,
            },
            {
              'title': 'Climate Impact Analysis',
              'subtitle': 'Temperature and precipitation changes',
              'description': 'ASTER thermal data combined with CERES radiation measurements reveal how deforestation affects local climate patterns and global carbon cycles.',
              'dataPoints': [
                'Local temperatures increased by 2°C',
                'Reduced rainfall in deforested areas',
                'Carbon emissions from forest loss',
              ],
              'color': AppTheme.asterColor,
            },
          ],
        };
        break;
      case 'arctic':
        regionData = {
          'name': 'Arctic Region',
          'description': 'Earth\'s northernmost region experiencing rapid change',
          'coordinates': '90°N, 0°W',
          'area': '14.05 million km²',
          'stories': [
            {
              'title': 'Arctic Sea Ice Decline',
              'subtitle': 'Monitoring ice extent changes',
              'description': 'Satellite observations show dramatic reductions in Arctic sea ice extent, with implications for global climate and sea level rise.',
              'dataPoints': [
                'Sea ice extent declining 13% per decade',
                'Summer ice minimum reached record lows',
                'Ice thickness also decreasing significantly',
              ],
              'color': AppTheme.primaryColor,
            },
          ],
        };
        break;
      default:
        regionData = {
          'name': 'Unknown Region',
          'description': 'Region data not available',
          'coordinates': 'N/A',
          'area': 'N/A',
          'stories': [],
        };
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildRegionImage(),
                _buildRegionInfo(),
                _buildStoriesSection(),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.surfaceColor,
      leading: IconButton(
        onPressed: () => context.go('/dashboard'),
        icon: const Icon(
          Icons.arrow_back,
          color: AppTheme.textPrimary,
        ),
      ),
      title: Text(
        regionData['name'],
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // TODO: Implement share functionality
          },
          icon: const Icon(
            Icons.share,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRegionImage() {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Satellite view placeholder
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.3),
                    AppTheme.backgroundColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // Overlay data visualization
            Positioned.fill(
              child: CustomPaint(
                painter: DataOverlayPainter(),
              ),
            ),
            
            // Region label
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Satellite View - ${regionData['name']}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRegionInfo() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              regionData['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              regionData['description'],
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildInfoChip('📍', regionData['coordinates']),
                const SizedBox(width: 12),
                _buildInfoChip('📏', regionData['area']),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(String icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStoriesSection() {
    final stories = regionData['stories'] as List<Map<String, dynamic>>;
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Data Stories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            );
          }
          
          final storyIndex = index - 1;
          if (storyIndex < stories.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: StoryCard(
                title: stories[storyIndex]['title'],
                subtitle: stories[storyIndex]['subtitle'],
                description: stories[storyIndex]['description'],
                dataPoints: List<String>.from(stories[storyIndex]['dataPoints']),
                color: stories[storyIndex]['color'],
              ),
            );
          }
          
          return const SizedBox(height: 100); // Bottom padding
        },
        childCount: stories.length + 2,
      ),
    );
  }
}

class DataOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw some data visualization overlays
    for (int i = 0; i < 20; i++) {
      final x = (i / 20) * size.width;
      final y = size.height * 0.7;
      
      paint.color = AppTheme.modisColor.withOpacity(0.6);
      canvas.drawCircle(Offset(x, y), 3, paint);
      
      paint.color = AppTheme.asterColor.withOpacity(0.4);
      canvas.drawCircle(Offset(x, y + 20), 2, paint);
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}