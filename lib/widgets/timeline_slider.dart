import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class TimelineSlider extends StatefulWidget {
  const TimelineSlider({super.key});

  @override
  State<TimelineSlider> createState() => _TimelineSliderState();
}

class _TimelineSliderState extends State<TimelineSlider>
    with TickerProviderStateMixin {
  late AnimationController _playbackController;
  
  static const int minYear = 1999;
  static const int maxYear = 2024;
  
  @override
  void initState() {
    super.initState();
    
    _playbackController = AnimationController(
      duration: Duration(seconds: (maxYear - minYear) * 2),
      vsync: this,
    );
    
    _playbackController.addListener(() {
      final appState = context.read<AppState>();
      if (appState.isPlaying) {
        final progress = _playbackController.value;
        final year = (minYear + (progress * (maxYear - minYear))).round();
        appState.setCurrentYear(year);
        
        if (_playbackController.isCompleted) {
          appState.setTimelinePlayback(false);
          _playbackController.reset();
        }
      }
    });
  }

  @override
  void dispose() {
    _playbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Play/Pause Button
                  _buildPlayButton(appState),
                  
                  const SizedBox(width: 16),
                  
                  // Year Display
                  _buildYearDisplay(appState),
                  
                  const SizedBox(width: 16),
                  
                  // Timeline Slider
                  Expanded(
                    child: _buildSlider(appState),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Speed Controls
                  _buildSpeedControls(appState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPlayButton(AppState appState) {
    return GestureDetector(
      onTap: () {
        if (appState.isPlaying) {
          _playbackController.stop();
          appState.setTimelinePlayback(false);
        } else {
          _playbackController.forward();
          appState.setTimelinePlayback(true);
        }
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          appState.isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),
    );
  }
  
  Widget _buildYearDisplay(AppState appState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        appState.currentYear.toString(),
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
  
  Widget _buildSlider(AppState appState) {
    return Column(
      children: [
        // Year markers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildYearMarker(minYear.toString()),
            _buildYearMarker('2005'),
            _buildYearMarker('2010'),
            _buildYearMarker('2015'),
            _buildYearMarker('2020'),
            _buildYearMarker(maxYear.toString()),
          ],
        ),
        
        const SizedBox(height: 4),
        
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryColor,
            inactiveTrackColor: AppTheme.textSecondary.withOpacity(0.3),
            thumbColor: AppTheme.primaryColor,
            overlayColor: AppTheme.primaryColor.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 8,
            ),
            trackHeight: 4,
          ),
          child: Slider(
            value: appState.currentYear.toDouble(),
            min: minYear.toDouble(),
            max: maxYear.toDouble(),
            divisions: maxYear - minYear,
            onChanged: appState.isPlaying ? null : (value) {
              appState.setCurrentYear(value.round());
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildYearMarker(String year) {
    return Text(
      year,
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 10,
      ),
    );
  }
  
  Widget _buildSpeedControls(AppState appState) {
    return Row(
      children: [
        _buildSpeedButton('0.5x', () {
          _playbackController.duration = Duration(seconds: (maxYear - minYear) * 4);
        }),
        const SizedBox(width: 4),
        _buildSpeedButton('1x', () {
          _playbackController.duration = Duration(seconds: (maxYear - minYear) * 2);
        }),
        const SizedBox(width: 4),
        _buildSpeedButton('2x', () {
          _playbackController.duration = Duration(seconds: maxYear - minYear);
        }),
      ],
    );
  }
  
  Widget _buildSpeedButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: AppTheme.textSecondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}