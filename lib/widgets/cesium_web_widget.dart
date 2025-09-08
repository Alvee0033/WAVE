import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

// Conditional import for web
import 'dart:html' as html show IFrameElement;

/// Web-compatible Cesium 3D Globe Widget
/// Uses HtmlElementView for Flutter web platform
class CesiumWebWidget extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback? onResetView;
  final Function(double lat, double lng)? onLocationChanged;
  final Map<String, dynamic>? dataLayers;
  
  const CesiumWebWidget({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onResetView,
    this.onLocationChanged,
    this.dataLayers,
  });

  @override
  State<CesiumWebWidget> createState() => _CesiumWebWidgetState();
}

class _CesiumWebWidgetState extends State<CesiumWebWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  String? _viewId;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeWebView();
    }
  }

  void _initializeWebView() {
    if (!kIsWeb) return;
    
    _viewId = 'cesium-globe-${DateTime.now().millisecondsSinceEpoch}';
    
    // Import the web-specific UI library
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewId!, (int viewId) {
      final iframe = _createCesiumIframe();
      return iframe;
    });
  }

  dynamic _createCesiumIframe() {
    if (!kIsWeb) return null;
    
    final iframe = html.IFrameElement()
      ..src = 'test/cesium_test.html'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
    
    return iframe;
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
            else if (kIsWeb && _viewId != null)
              _buildWebWidget()
            else
              _buildFallbackWidget(),
            
            if (_isLoading && !_hasError)
              _buildLoadingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebWidget() {
    // ignore: undefined_prefixed_name
    return HtmlElementView(viewType: _viewId!);
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
              color: Color(0xFF2196F3),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              '3D Globe Preview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Web platform not supported',
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
              'Failed to load 3D Globe',
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
                _initializeWebView();
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
}


